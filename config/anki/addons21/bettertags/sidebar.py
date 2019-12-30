# -*- coding: utf-8 -*-

# BetterTags Add-on for Anki
#
# Copyright (C) 2017-2019  Aristotelis P. <https//glutanimate.com/>
# Copyright (C) 2014       Patrice Neff <http://patrice.ch/>
#                          (Hierarchical Tags)
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
Modifications to the card browser sidebar
"""

from __future__ import unicode_literals

import re

from aqt.qt import *
from aqt.utils import getText, askUser

from anki.hooks import runHook

from .consts import anki21
from .config import local_conf

HOTKEY_DELETE = local_conf["hotkeyDeleteTag"]
HOTKEY_RENAME = local_conf["hotkeyRenameTag"]
HOTKEY_REORG = "Shift+{}".format(HOTKEY_RENAME)
SEPARATOR = local_conf["hierarchicalTagsSeparator"]
TAGWIDGETITEM_TYPE_DEFAULT = 0
TAGWIDGETITEM_TYPE_TAG = 1

if anki21:
    TAG_ICON = ":/icons/tag.svg"
else:
    TAG_ICON = ":/icons/anki-tag.png"


# GUI MODIFICATIONS ###################

# Common ###################

# QTreeWidget modifications


def mySetupTree(self, _old):
    """
    Apply modifications to the sidebar QTreeWidget

    Arguments:
        _old {function} -- Original setupTree()
    """

    # tags to expand
    self.sidebar_expand = []

    _old(self)

    if anki21:
        tree = self.sidebarTree
    else:
        tree = self.form.tree

    # Enable context menu
    tree.setContextMenuPolicy(Qt.CustomContextMenu)
    tree.customContextMenuRequested.connect(self.onTreeContext)

    # Enable drag-and-drop
    tree.setDragEnabled(True)
    tree.setSelectionMode(QAbstractItemView.ExtendedSelection)
    tree.viewport().setAcceptDrops(True)
    tree.setDragDropMode(QAbstractItemView.InternalMove)
    tree.dropEvent = lambda e: dropEvent(tree, self, e)

    s = QShortcut(QKeySequence(_(HOTKEY_RENAME)), tree)
    s.activated.connect(lambda t=tree: self.onSidebarTagHotkey(tree, "rename"))
    s = QShortcut(QKeySequence(_(HOTKEY_REORG)), tree)
    s.activated.connect(lambda t=tree: self.onSidebarTagHotkey(tree, "reorg"))
    s = QShortcut(QKeySequence(_(HOTKEY_DELETE)), tree)
    s.activated.connect(lambda t=tree: self.onSidebarTagHotkey(tree, "delete"))


# QTreeWidgetItem modifications

class CustomCallbackItem(QTreeWidgetItem):
    """
    Initiliazes a browse sidebar QTreeWidgetItem with custom
    properties and methods

    Modified version of aqt.browser.Browser.CallbackItem

    Arguments:
        root {QTreeWidget/QTreeWidgetItem} -- Parent Qt element
        name {str} -- User-visible name
        onclick {function} -- Function executed upon left-clicking
                              on the item

    Keyword Arguments:
        oncollapse {function} -- Function executed when item is collapsed
                                 (default: {None})
        expanded {bool} -- Whether or not to expand item (default: {False})
        draggable {bool} -- Whether or not item should be draggable
                            (default: {False})
        itype {int} -- Item type. 0 for default item. 1 for tag item.
                       (default: {TAGWIDGETITEM_TYPE_DEFAULT})
        idata {str} -- Extra data associated with the item, e.g. the
                       partial tag in case of hierarchical tags (default: {""})
    """
    # TODO: consider inheriting from anki CallbackItem

    def __init__(self, root, name, onclick, oncollapse=None,
                 expanded=False, draggable=False,
                 itype=TAGWIDGETITEM_TYPE_DEFAULT, idata=""):

        QTreeWidgetItem.__init__(self, root, [name])

        self.setExpanded(expanded)

        # QTreeWidgetItems have DnD enabled by default if the
        # parent QTreeWidget supports it. We don't want DnD for all
        # sidebar items, so disable it by default:
        self.setDraggable(draggable)

        self.onclick = onclick
        self.oncollapse = oncollapse

        # Create additional properties for better interop with
        # other parts of the add-on
        self.itype = itype
        self.idata = idata

    def setDraggable(self, draggable):
        """
        Toggle between draggable states

        Arguments:
            draggable {boolean} -- Whether or not to enable dragging for item
        """
        if draggable:
            self.setFlags(self.flags() |
                          Qt.ItemIsDragEnabled | Qt.ItemIsDropEnabled)
        else:
            self.setFlags(self.flags() &
                          ~Qt.ItemIsDragEnabled & ~Qt.ItemIsDropEnabled)


# Hierarchical Tags ###################

def regularUserTagTree(self, root):
    """
    Add tag tree items to the browse sidebar
    (non-hierarchical)

    Modified version of aqt.browser.Browser.userTagTree

    Arguments:
        root {QTreeWidget/QTreeWidgetItem} -- Parent Qt element to add
                                              items to
    """
    expand_tags = self.sidebar_expand
    last_selected = None

    for t in sorted(self.col.tags.all(), key=lambda t: t.lower()):

        item = self.CallbackItem(root, t, lambda t=t: self.setFilter("tag", t))
        item.setIcon(0, QIcon(TAG_ICON))
        item.itype = TAGWIDGETITEM_TYPE_TAG
        item.idata = t

        if t in expand_tags:
            item.setSelected(True)
            last_selected = item

    if last_selected:
        # scroll, center, and select
        root.scrollToItem(last_selected, QAbstractItemView.PositionAtCenter)
        if len(expand_tags) == 1:
            root.setCurrentItem(last_selected, 0)

    self.sidebar_expand = []


def hierarchicalUserTagTree(self, root):
    """
    Add tag tree items to the browse sidebar
    (hierarchical)

    Modified version of aqt.browser.Browser.userTagTree

    Arguments:
        root {QTreeWidget/QTreeWidgetItem} -- Parent Qt element to add
                                              items to
    """
    # get tags & prepare tag tree dict
    tags = sorted(self.col.tags.all())
    tags_tree = {}

    # get tags that are to be expanded / selected
    expand_tags = self.sidebar_expand
    last_selected = None

    # for each tag in collection
    for t in tags:
        if t.lower() == "marked" or t.lower() == "leech":
            # skip over Anki-reserved tags
            continue

        components = t.split(SEPARATOR)
        # for each component in hierarchical tag
        for idx, c in enumerate(components):
            # tag hierarchy up to the current component:
            partial_tag = SEPARATOR.join(components[0:idx + 1])
            # is this the first time we encounter this hierarchy?
            if not tags_tree.get(partial_tag):
                if idx == 0:
                    parent = root
                else:
                    parent_tag = SEPARATOR.join(components[0:idx])
                    parent = tags_tree[parent_tag]

                # Create item, add it to the parent, set properties
                item = self.CallbackItem(
                    parent, c, None, draggable=True)
                item.onclick = lambda i=item, t=partial_tag: self.onTagClick(
                    i, t)
                item.setIcon(0, QIcon(TAG_ICON))
                item.itype = TAGWIDGETITEM_TYPE_TAG
                item.idata = partial_tag

                if partial_tag in expand_tags:
                    expandItem(item)
                    item.setSelected(True)
                    last_selected = item

                tags_tree[partial_tag] = item

    if last_selected:
        # scroll, center, and select
        root.scrollToItem(last_selected, QAbstractItemView.PositionAtCenter)
        if len(expand_tags) == 1:
            root.setCurrentItem(last_selected, 0)

    # reset tags to expand
    self.sidebar_expand = []


def expandItem(item):
    parent = item.parent()
    if parent:
        parent.setExpanded(True)
        expandItem(parent)


def onTagClick(self, item, tag):
    """
    Set search filter for tag items depending on
    their level in hierarchy

    Arguments:
        item {CustomCallbackItem} -- Sidebar item clicked on
        tag {str} -- Associated partial tag
    """
    if item.childCount():  # has children
        self.setFilter('("tag:{0}" or "tag:{0}{1}*")'.format(tag, SEPARATOR))
    else:
        self.setFilter("tag", tag)


# Drag & Drop ###################

def dropEvent(self, browser, event):
    """
    Custom QTreeWidget drop event handler

    self is sidebar QTreeWidget
    (Anki 2.1: SidebarTreeWidget; Anki 2.0: QTreeWidget)

    Arguments:
        event {QDropEvent} -- Qt drop event
    """
    source = self.currentItem()
    all_sources = self.selectedItems()
    droppedon_idx = self.indexAt(event.pos())
    droppedon = self.itemFromIndex(droppedon_idx)
    indicator_pos = self.dropIndicatorPosition()

    # Need to ignore default action, otherwise we run into weird
    # Qt behavior, especially on Qt4
    event.setDropAction(Qt.IgnoreAction)

    try:
        droppedon_is_tag = droppedon.itype == TAGWIDGETITEM_TYPE_TAG
    except AttributeError:
        droppedon_is_tag = False

    if not droppedon_is_tag:
        # Target not a tag. Return.
        return QTreeWidget.dropEvent(self, event)

    if indicator_pos == QAbstractItemView.OnItem:
        # released on top of other item
        target = droppedon
    else:
        # released between items
        target = droppedon.parent()

    if target == source:
        # Drag and drop between same level. Return.
        return QTreeWidget.dropEvent(self, event)

    target_is_root = not bool(target)
    target_tag = "" if target_is_root else target.idata


    last_idx = len(all_sources) - 1
    for idx, source_item in enumerate(all_sources):
        if source_item.itype != TAGWIDGETITEM_TYPE_TAG:
            continue
        if last_idx == 0:
            batch_state = ""
        elif idx == 0:
            batch_state = "start"
        elif idx == last_idx:
            batch_state = "done"
        else:
            batch_state = "batch"
        source_tag = source_item.idata
        browser.onSidebarTagReposition(
            source_tag, target_tag, batch_state=batch_state)
    
    return QTreeWidget.dropEvent(self, event)


# Sidebar Context Menu ###################

def onTreeContext(self, pos):
    """
    Draw context menu at position

    Arguments:
        pos {QPoint} -- Right-click position
    """
    if anki21:
        tree = self.sidebarTree
    else:
        tree = self.form.tree

    gpos = tree.mapToGlobal(pos)
    item = tree.itemAt(pos)
    # Only draw for tag items:
    if item is None or item.itype != TAGWIDGETITEM_TYPE_TAG:
        return

    # Multiple selections are not supported for now:
    selected = tree.selectedItems()
    if selected and len(selected) > 1:
        return

    (tag_string, is_hierarchy,
        child_count, select_after) = self.getTagItemData(tree, item)

    m = QMenu()
    m.addAction("Rename tag...\t{}".format(_(HOTKEY_RENAME)),
                lambda t=tag_string, h=is_hierarchy:
                    self.onSidebarTagReplace(t, h))
    if is_hierarchy:
        m.addAction("Rename full tag...\t{}".format(_(HOTKEY_REORG)),
                    lambda t=tag_string, h=is_hierarchy:
                        self.onSidebarTagReplace(t, h, rename_full=True))
    m.addAction("Delete tag\t{}".format(_(HOTKEY_DELETE)),
                lambda t=tag_string, h=is_hierarchy, s=select_after:
                    self.onSidebarTagDelete(t, h, select_after=s))
    m.addSeparator()
    m.addAction("Filtered deck...",
                lambda t=tag_string, c=child_count:
                    self.onSidebarFilteredDeck(t, c))

    # Allow other add-on authors to modify the context menu:
    runHook("Browser.tagContextMenuEvent", self, m, item)
    m.exec_(gpos)


def getTagItemData(self, tree, item):
    """
    Return pertinent information on provided tag tree item
    for further processing.

    Arguments:
        tree {QTreeWidget} -- Browser sidebar QTreeWidget
        item {CustomCallbackItem} -- QTreeWidgetItem to return data on

    Returns:
        tuple -- Contains: tag_string{str}, is_hierarchy{boolean},
                           select_after{str}
    """

    # If item has a parent or children it's part of a hierarchy:
    parent = item.parent()
    child_count = item.childCount()
    is_hierarchy = bool(parent or child_count)

    # Make sure to select a neighbouring item in case of item deletion:
    if child_count:
        # children will also be deleted, so item below is no good
        # TODO: determine next top-level item instead
        select_item = tree.itemAbove(item)
    else:
        select_item = tree.itemBelow(item) or tree.itemAbove(item)
    select_after = select_item.text(0) if select_item else None

    tag_string = item.idata

    return tag_string, is_hierarchy, child_count, select_after


# TAG ACTIONS ###################

# Called from context menu / hotkey ###################

def onSidebarFilteredDeck(self, tag, child_count):
    """
    Create filtered deck from sidebar
    
    Arguments:
        tag {str} -- Partial tag to create filtered deck with
        child_count {int} -- Number of children. Determines if we
                             do a wild card search or not
    """
    if child_count:
        search = '("tag:{0}" or "tag:{0}{1}*")'.format(tag, SEPARATOR)
    else:
        search = '"tag:{}"'.format(tag)
    self.mw.onCram(search)

def onSidebarTagDelete21(self, tag, is_hierarchy, select_after=None):
    """
    Ask user for confirmation, then delete provided tag
    and (in case of hierarchy) all subtags
    (Anki 2.1 wrapper)

    Arguments:
        tag {str} -- Tag (hierarchy) to be deleted
        is_hierarchy {bool} -- Whether or not tag is part of a hierarchy

    Keyword Arguments:
        select_after {str} -- Name of tag item to select after
                              modifications have been performed
                              (default: {None})
    """
    return self.editorSaveThenRun(
        self._onSidebarTagDelete, tag, is_hierarchy,
        select_after)


def onSidebarTagDelete(self, tag, is_hierarchy, select_after=None):
    """
    Ask user for confirmation, then delete provided tag
    and (in case of hierarchy) all subtags

    Arguments:
        tag {str} -- Tag (hierarchy) to be deleted
        is_hierarchy {bool} -- Whether or not tag is part of a hierarchy

    Keyword Arguments:
        select_after {str} -- Name of tag item to select after
                              modifications have been performed
                              (default: {None})
    """
    q = ("This will <b>delete</b> the tag <i>{}</i> in "
         "<b>all of your notes.</b>"
         "<br><br>Are you sure you want to proceed?".format(tag))
    if is_hierarchy:
        q += ("<br<br><br><b>Warning</b>: You have selected to remove a "
              "<b>hierarchical tag</b>. All subtags underneath it "
              "will also be removed if you proceed!")

        find = r"^{}({}.*|$)".format(re.escape(tag), SEPARATOR)
        search = '"tag:{}*"'.format(tag)
        args = {
            "find": find, "replace": "", "nids": [],
            "whole_tags": False, "regex": True,
            "search_pre": search,
            "search_post": search,
            "show_info": False
        }
    else:
        search = '"tag:{}"'.format(tag)
        args = {
            "find": tag, "replace": "", "nids": [],
            "whole_tags": True, "regex": False,
            "search_pre": search,
            "search_post": search,
            "show_info": False
        }

    if not askUser(q, parent=self, defaultno=True, title="Delete tag"):
        return

    if select_after:
        self.sidebar_expand.append(select_after)

    self.doFindAndReplaceTags(**args)


def onSidebarTagReplace21(self, tag, is_hierarchy, rename_full=False):
    """
    Replace provided tag with user-entered string
    (Anki 2.1 wrapper)

    Arguments:
        tag {str} -- Tag (hierachy) to replace
        is_hierarchy {bool} -- Whether or not tag is part of a hierarchy

    Keyword Arguments:
        rename_full {bool} -- Whether or not to replace full tag hierarchy
                              instead of just current level (default: {False})
    """
    return self.editorSaveThenRun(
        self._onSidebarTagReplace, tag, is_hierarchy,
        rename_full)


def onSidebarTagReplace(self, tag, is_hierarchy, rename_full=False):
    """
    Replace provided tag with user-entered string

    Arguments:
        tag {str} -- Tag (hierachy) to replace
        is_hierarchy {bool} -- Whether or not tag is part of a hierarchy

    Keyword Arguments:
        rename_full {bool} -- Whether or not to replace full tag hierarchy
                              instead of just current level (default: {False})
    """
    if is_hierarchy and not rename_full:
        components = tag.split(SEPARATOR)
        last_comp = components[-1]
        preceding_comp = SEPARATOR.join(components[:-1])
        root = tag == last_comp
        original = last_comp
    else:
        original = tag

    user_input, ret = getText("New name:", parent=self, title="Rename tag",
                              default=original)
    if not ret:
        return

    if is_hierarchy and not rename_full:
        if preceding_comp:
            prefix = "{}{}".format(preceding_comp, SEPARATOR)
        else:
            prefix = ""

        if root:
            find = r"^({})({}.*|$)".format(re.escape(last_comp), SEPARATOR)
            # need to escape potential backslashes in user input
            # (re.escape only work for matching strings):
            replace = r"{}\g<2>".format(user_input.replace('\\', '\\\\'))
        else:
            find = r"^({})({})({}.*|$)".format(re.escape(prefix),
                                               re.escape(last_comp),
                                               SEPARATOR)
            replace = r"\g<1>{}\g<3>".format(user_input.replace('\\', '\\\\'))

        new_tags = components[:-1] + [user_input]

        args = {
            "find": find, "replace": replace, "nids": [],
            "whole_tags": False, "regex": True,
            "search_pre": '"tag:{}*"'.format(tag),
            "search_post": '"tag:{}*"'.format(SEPARATOR.join(new_tags)),
            "show_info": False
        }

    elif rename_full:
        find = r"^({})({}.*|$)".format(re.escape(original), SEPARATOR)
        replace = r"{}\g<2>".format(user_input.replace('\\', '\\\\'))
        new_tags = user_input.split(SEPARATOR)

        args = {
            "find": find, "replace": replace, "nids": [],
            "whole_tags": False, "regex": True,
            "search_pre": '"tag:{}*"'.format(tag),
            "search_post": '"tag:{}*"'.format(user_input),
            "show_info": False
        }

    else:
        # need to split in case user has replaced a regular tag with
        # a hierarchical tag:
        if local_conf["enableHierarchicalTags"]:
            new_tags = user_input.split(SEPARATOR)
        else:
            new_tags = [user_input]

        args = {
            "find": original, "replace": user_input, "nids": [],
            "whole_tags": True, "regex": False,
            "search_pre": '"tag:{}"'.format(original),
            "search_post": '"tag:{}"'.format(user_input),
            "show_info": False
        }

    # note down tag hierarchy that is to be expanded / selected
    self.sidebar_expand.append(SEPARATOR.join(new_tags))

    self.doFindAndReplaceTags(**args)


# Called from hotkey ###################

def onSidebarTagHotkey(self, tree, action):
    """
    Determine data of currently selected item and perform
    provided action

    Arguments:
        tree {QTreeWidget} -- Browser sidebar tree widget
        action {str} -- Tag action to perform (rename/reorg/delete)
    """
    item = tree.selectedItems()[0]

    # Only proceed for tag items:
    if item is None or item.itype != TAGWIDGETITEM_TYPE_TAG:
        return

    (tag_string, is_hierarchy,
        child_count, select_after) = self.getTagItemData(tree, item)

    if action == "rename":
        self.onSidebarTagReplace(tag_string, is_hierarchy)
    elif is_hierarchy and action == "reorg":
        self.onSidebarTagReplace(tag_string, is_hierarchy, rename_full=True)
    elif action == "delete":
        self.onSidebarTagDelete(tag_string, is_hierarchy,
                                select_after=select_after)


# Called from drag & drop ###################

def onSidebarTagReposition21(self, source_tag, target_tag, batch_state=""):
    """
    Reposition tag under different parent tag
    (Anki 2.1 wrapper)

    Arguments:
        source_tag {str} -- Tag (hierarchy) to reposition
        target_tag {str} -- New tag (hierarchy) to position source tag under.
                            Leave blank to position tag under root tree.
    
    Keyword Arguments:
        batch_state {str} -- String indicating process state when performing
                             batch operations. Possible values: "start",
                             "batch", "done". Different states control which
                             widget reset actions are performed by
                             browser.doFindAndReplaceTags
                             Defaults to "" (no batch action).
    """
    return self.editorSaveThenRun(self._onSidebarTagReposition, source_tag,
                                  target_tag, batch_state=batch_state)


def onSidebarTagReposition(self, source_tag, target_tag, batch_state=""):
    """
    Reposition tag under different parent tag

    Arguments:
        source_tag {str} -- Tag (hierarchy) to reposition
        target_tag {str} -- New tag (hierarchy) to position source tag under.
                            Leave blank to position tag under root tree.
    
    Keyword Arguments:
        batch_state {str} -- String indicating process state when performing
                            batch operations. Possible values: "start",
                            "batch", "done". Different states control which
                            widget reset actions are performed by
                            browser.doFindAndReplaceTags
                            Defaults to "" (no batch action).
    """
    components = source_tag.split(SEPARATOR)
    last_node = components.pop()
    source_tag_stem = (SEPARATOR.join(components) +
                       SEPARATOR) if components else ""

    find = r"^{}(({})({}.*|$))".format(re.escape(source_tag_stem),
                                       re.escape(last_node),
                                       SEPARATOR)

    if target_tag:  # other tag
        replace = "{}{}\g<1>".format(target_tag.replace('\\', '\\\\'),
                                     SEPARATOR)
        new_tags = target_tag.split(SEPARATOR) + [last_node]
    else:  # root tree
        replace = "\g<1>"
        new_tags = [last_node]

    args = {
        "find": find, "replace": replace, "nids": [],
        "whole_tags": False, "regex": True,
        "search_pre": '"tag:{}*"'.format(source_tag),
        "search_post": '"tag:{}*"'.format(SEPARATOR.join(new_tags)),
        "show_info": False, "batch_state": batch_state
    }

    self.sidebar_expand.append(SEPARATOR.join(new_tags))

    self.doFindAndReplaceTags(**args)
