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
Modifications to the tag entry field
"""

from __future__ import unicode_literals

import re

from aqt.qt import *
from aqt import tagedit

from .consts import anki21
from .config import local_conf

OldTagEdit = tagedit.TagEdit
OldTagCompleter = tagedit.TagCompleter

if anki21:
    QSOViewItem = QStyleOptionViewItem
else:
    QSOViewItem = QStyleOptionViewItemV4

SEPARATOR = local_conf["hierarchicalTagsSeparator"]
# Switch to arbitrary substrings either if set by user or if
# hierarchical tags disabled
ARBITRARY_SUBSTRINGS = (local_conf["hierarchicalCompleterArbitrarySubstrings"] or
                        not local_conf["enableHierarchicalTags"])
HIGHLIGHT_WORKAROUND = local_conf["hierarchicalCompleterHighlightWorkaround"]


class HTMLDelegate(QStyledItemDelegate):
    """
    Custom item delegate for QCompleter popup that
    allows us to render rich text
    """

    def __init__(self, *args):
        QStyledItemDelegate.__init__(self, *args)
        self.prefix = None

    def paint(self, painter, option, index):
        options = QSOViewItem(option)
        self.initStyleOption(options, index)
        if options.widget is None:
            style = QApplication.style()
        else:
            style = options.widget.style()

        # Highlight search term
        prefix = self.prefix
        if prefix:
            text = options.text
            pfx = re.escape(prefix.lower())

            if ARBITRARY_SUBSTRINGS:
                re_match = r"({})".format(pfx)
                re_replace = r"<b>\1</b>"
                text = re.sub(re_match, re_replace, text, flags=re.I)
            else:
                re_match = r"({1})({0})".format(pfx, SEPARATOR)
                re_replace = r"{0}<b>\2</b>".format(SEPARATOR)
                text = re.sub(re_match, re_replace, text, flags=re.I)

                re_match = "^({0})".format(pfx)
                re_replace = r"<b>\1</b>"
                text = re.sub(re_match, re_replace, text, flags=re.I)

            options.text = text

        doc = QTextDocument()
        doc_option = doc.defaultTextOption()
        doc_option.setWrapMode(QTextOption.NoWrap)
        doc.setDefaultTextOption(doc_option)
        doc.setHtml(options.text)
        doc.setTextWidth(option.rect.width())
        doc.setDocumentMargin(0)  # fix lines being cut off

        options.text = ""
        style.drawControl(QStyle.CE_ItemViewItem, options, painter)

        ctx = QAbstractTextDocumentLayout.PaintContext()

        # Highlighting text if item is selected
        if options.state & QStyle.State_Selected:
            ctx.palette.setColor(QPalette.Text,
                                 options.palette.color(QPalette.Active,
                                                       QPalette.HighlightedText))

        textRect = style.subElementRect(QStyle.SE_ItemViewItemText,
                                        options)
        painter.save()
        painter.translate(textRect.topLeft())
        if not HIGHLIGHT_WORKAROUND:
            # Improve text spacing. Does not work properly on Linux, thus
            # the need for the workaround switch
            painter.setClipRect(textRect.translated(-textRect.topLeft()))
        doc.documentLayout().draw(painter, ctx)
        painter.restore()


class CustomTagEdit(OldTagEdit):
    """
    Custom TagEdit Widget with support for custom TagCompleter

    Arguments:
        parent {QWidget} -- Parent Qt widget

    Keyword Arguments:
        type {int} -- Tag edit type to create. 0 for tag selection,
                      1 for deck selection. (default: {0})
    """
    
    def __init__(self, parent, type=0):
        OldTagEdit.__init__(self, parent, type=type)
        self.type = type
        # TODO: find a way to use filtered PopupCompletion:
        # (cf. https://stackoverflow.com/q/5129211/1708932)
        self.completer.setCompletionMode(QCompleter.UnfilteredPopupCompletion)

    def setCol(self, col):
        """
        Set the current collection, updateing list of available tags
        
        Arguments:
            col {anki.collection._Collection} -- Anki collection
        """
        super(CustomTagEdit, self).setCol(col)
        self.completer.strings = self.model.stringList()

    def showCompleter(self):
        """
        Overwrite default showCompleter with method that first calls
        completer.update() for tags before performing completion
        """
        if self.type == 0:  # tag selection
            self.completer.update(self.text())
        else:  # deck selection
            self.completer.setCompletionPrefix(self.text())
        self.completer.complete()


class CustomTagCompleter(OldTagCompleter):
    """
    Custom Tag Completer that performs substring matches and highlights results

    Arguments:
        model {QStringListModel} -- Autocompleter model
        parent {QWidget} -- Parent Qt widget
        edit {CustomTagEdit} -- Tag edit completer is attached to
    """

    def __init__(self, model, parent, edit, *args):
        OldTagCompleter.__init__(self, model, parent, edit, *args)
        self.strings = []
        self.delegate = HTMLDelegate()

    def update(self, prefix):
        """
        Update completer model string list based on tags matching
        supplied prefix
        
        Arguments:
            prefix {string} -- Tag prefix to autocomplete for
        """
        if not self.tags:
            return

        prefix = [self.tags[self.cursor or 0]][0]
        pfx = prefix.lower()
        strings = self.strings

        if not pfx:
            filtered = strings
        else:
            if ARBITRARY_SUBSTRINGS:
                filtered = [s for s in strings if pfx in s.lower()]
            else:
                hierarchical_pfx = "{}{}".format(SEPARATOR, pfx)
                filtered = [s for s in strings
                            if hierarchical_pfx in s.lower() or
                            s.lower().startswith(pfx)]
        
        self.model().setStringList(filtered)

        self.delegate.prefix = prefix
        self.popup().setItemDelegate(self.delegate)
