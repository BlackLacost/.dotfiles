# -*- coding: utf-8 -*-

# BetterTags Add-on for Anki
#
# Copyright (C) 2017-2019  Aristotelis P. <https//glutanimate.com/>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version, with the additions
# listed at the end of the accompanied license file.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# NOTE: This program is subject to certain additional terms pursuant to
# Section 7 of the GNU Affero General Public License.  You should have
# received a copy of these additional terms immediately following the
# terms and conditions of the GNU Affero General Public License which
# accompanied this program.
#
# If not, please request a copy through one of the means of contact
# listed here: <https://glutanimate.com/contact/>.
#
# Any modifications to this file must keep this entire header intact.

"""
Modifications to the card browser, precluding the sidebar
"""

from __future__ import unicode_literals

import sre_constants

from aqt.qt import *

from anki.lang import ngettext
from aqt.utils import tooltip, showInfo
from anki.utils import ids2str

from anki.hooks import runHook

from .find import findReplaceTags, getSearchString
from .gui.dialogs import FindAndReplaceTagsDialog

from .consts import *
from .config import local_conf

HOTKEY_FIND_REPLACE = local_conf["hotkeyFindReplace"]
HOTKEY_REFRESH_TAGS = local_conf["hotkeyRefreshTags"]
CHECKPOINT_NAME = "Batch BetterTags Actions"


def editorSaveThenRun(self, callback, *args, **kwargs):
    """
    Prompt editor to save and then run callback

    This is required on Anki 2.1 because changes to the editor widget
    are asynchronous.

    self is an aqt.browser.Browser instance
    """
    self.editor.saveNow(lambda: callback(*args, **kwargs))


def onFindReplaceTags(self):
    """
    Call Find and Replace Dialog and pass
    settings on to doFindAndReplaceTags().

    self is an aqt.browser.Browser instance
    """

    nids = self.selectedNotes()
    total_count = self.col.noteCount()

    repl_tags = self.col.tags.all()
    if nids:
        find_tags = set(self.col.tags.split(" ".join(self.col.db.list(
            "select distinct tags from notes where id in " + ids2str(nids)))))
    else:
        find_tags = repl_tags

    dialog = FindAndReplaceTagsDialog(self, find_tags, repl_tags,
                                      count=len(nids), total=total_count)
    ret = dialog.exec_()

    if not ret:
        return

    args = dialog.getInputs()

    if not args["find"]:
        tooltip("No changes performed.", parent=self)
        return False

    limit = args.pop("limit")
    args["nids"] = nids if limit else []

    if not args["regex"]:
        args["search_pre"] = getSearchString(
            args["find"], args["whole_tags"])
        args["search_post"] = getSearchString(
            args["replace"], args["whole_tags"])

    return self.doFindAndReplaceTags(**args)


def doFindAndReplaceTags(self, find="", replace="", nids=[],
                         whole_tags=True, ignore_case=False, regex=False,
                         search_pre="", search_post="", show_info=True,
                         batch_state=""):
    """
    Main function for performing tag modifications.

    Determine pertinent notes, create collection checkpoint, then
    run findReplaceTags() on notes with provided settings and
    optionally inform user of the result
    
    Keyword Arguments:
        find {str} -- Tag string to match (default: {""})
        replace {str} -- Tag string to replace match with (default: {""})
        nids {list} -- List of nids to process. If left blank, will try
                       to determine pertinent notes automatically.
                       (default: {[]})
        whole_tags {bool} -- Perform exact word match on tag string
                             (default: {True})
        ignore_case {bool} -- Match case-insensitively (default: {False})
        regex {bool} -- Treat 'find' and 'replace' as regular
                        expressiosn (default: {False})
        search_pre {str} -- Search string to narrow down automatically
                            determined nids with (default: {""})
        search_post {str} -- Search string to set GUI browser search
                             to after changes have been performed.
                             Leave blank to perform no search. (default: {""})
        show_info {bool} -- Whether or not to show an info message after the
                            changes have been performed (default: {True})
        batch_state {str} -- String indicating process state when performing
                             batch operations. Possible values: "start",
                             "batch", "done". Different states control which
                             widget reset actions are performed.
                             Defaults to "" (no batch action).
    
    Returns:
        int -- Number of modified notes
    """
    # TODO: find more elegant way to handle batch tag actions, e.g. by passing
    # find / replace strings as tuples and looping over each within the method
    
    if nids:
        total = len(nids)
    else:
        total = self.col.noteCount()
        if search_pre:
            nids = self.col.findNotes(search_pre)

    if not batch_state or batch_state == "start":
        # either running a single-shot tag action or starting
        # batch action
        self.mw.checkpoint(CHECKPOINT_NAME)
        self.mw.progress.start()
        self.model.beginReset()

    try:
        changed = findReplaceTags(self.col, nids, find, replace,
                                  whole_tags=whole_tags, regex=regex,
                                  ignore_case=ignore_case)

    except sre_constants.error as e:
        print(e)
        showInfo(_("Invalid regular expression."), parent=self)
        return

    else:
        if not batch_state or batch_state == "done":
            # either running a single-shot tag action or finalizing
            # batch action
            if search_post:
                self.form.searchEdit.lineEdit().setText(search_post)

            if anki21:
                self.onSearchActivated()
            else:
                self.onSearch()
            self.mw.requireReset()

    finally:
        if not batch_state or batch_state == "done":
            # Trigger collection tag refresh
            # (not passing nids → trigger full refresh):
            self.col.tags.registerNotes()
            # TODO: investigate if the following two calls are actually
            # necessary after tag edits:
            self.col.updateFieldCache(nids)
            self.col.genCards(nids)
            
            self.model.endReset()
            self.mw.progress.finish()
            self._tag_action_performed = True

    if show_info:
        showInfo(ngettext(
            "%(a)d of %(b)d note updated",
            "%(a)d of %(b)d notes updated", total) % {
                'a': changed,
                'b': total,
        }, parent=self)

    return changed


def onRefreshTags(self):
    """
    Update tag database, removing unused notes and refreshing
    tag hierarchies
    """
    self.mw.col.tags.registerNotes()
    tooltip("Updated tag database.")


# Undo tag actions
# TODO: Find a more elegant way to do this. Might have to submit
# a PR to Anki to allow add-on authors better control of undo actions.

def onUndoBefore(self):
    self._undoName = self.mw.col.undoName()

def onUndoAfter(self):
    name = getattr(self, "_undoName", None)
    if not name:
        return
    elif name == CHECKPOINT_NAME:
        # refresh tags and sidebar
        self.mw.col.tags.registerNotes()
        self._undoName = None
    
def setupMenuWrap(self, _old):
    """
    Wrap setupMenu in order to connect actionUndo to additional
    methods in a pre-specified order.
    """
    self.form.actionUndo.triggered.connect(self.onUndoBefore)
    ret = _old(self)
    self.form.actionUndo.triggered.connect(self.onUndoAfter)
    return ret

# Menu entries

def setupMenu(self):
    """
    Add menu entries to Browser

    self is an aqt.browser.Browser instance
    """

    try:
        # The Tags menu is used by several of my add-ons,
        # so we check for its existence first:
        menu = self.menuTags
    except AttributeError:
        # Tags menu does not exist, so create it from scratch
        self.menuTags = QMenu(_("&Tags"))
        self.menuBar().insertMenu(self.mw.form.menuTools.menuAction(),
                                  self.menuTags)

    menu = self.menuTags
    menu.addSeparator()

    # Add submenus, assign them shortcuts, and connect them
    # to their respective functions
    a = menu.addAction('Find and Replace Tags...')
    a.setShortcut(QKeySequence(HOTKEY_FIND_REPLACE))
    if anki21:
        a.triggered.connect(lambda: self.editorSaveThenRun(
            self.onFindReplaceTags))
    else:
        a.triggered.connect(self.onFindReplaceTags)

    a = menu.addAction('Refresh Tag List...')
    a.setShortcut(QKeySequence(HOTKEY_REFRESH_TAGS))
    if anki21:
        a.triggered.connect(lambda: self.editorSaveThenRun(
            self.onRefreshTags))
    else:
        a.triggered.connect(self.onRefreshTags)


# TODO: Submit pull request to dae/anki to allow add-on authors to add
# menu actions without overwriting onContextMenu
def onResultListContextMenu(self, _point):
    """
    Patch aqt.browser.Browser.onContextMenu to add "Find and Replace
    Tags" action to the result list context menu

    self is an aqt.browser.Browser instance
    """
    m = QMenu()
    for act in self.form.menu_Cards.actions():
        m.addAction(act)
    m.addSeparator()
    for act in self.form.menu_Notes.actions():
        m.addAction(act)
    # mod start
    m.addSeparator()
    a = m.addAction('Find and Replace Tags...')
    a.setShortcut(QKeySequence(HOTKEY_FIND_REPLACE))
    a.triggered.connect(lambda: self.editorSaveThenRun(
        self.onFindReplaceTags))
    runHook("Browser.contextMenuEvent", self, m)
    # mod stop
    m.exec_(QCursor.pos())
