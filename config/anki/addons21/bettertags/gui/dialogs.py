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
Associated dialogs
"""

from __future__ import unicode_literals

from aqt.qt import *
from aqt.tagedit import TagEdit
from aqt.utils import openLink, saveGeom, restoreGeom, askUser
from anki.utils import isMac, isWin

from ..consts import *

from .forms import findreplacetags

help_link = "https://github.com/glutanimate/find-and-replace-tags/wiki"
support_author_link = ("https://glutanimate.com/tip-jar/")


class CustomTagEdit(TagEdit):
    """
    Custom QLineEdit widget inheriting from TagEdit

    Modifications as compared to aqt.TagEdit:

    - use QCompleter instead of TagCompleter for autocompletions
      (TagCompleter is designed for completing multiple tags, but
      we only need to complete one)
    - use simplified focus events in order to avoid issues with
      completer popups
    - ability to set custom selection of tags to complete from
    - ability to toggle auto-completions on demand
    - validate user input

    Arguments:
        parent {QWidget} -- Parent Qt widget
    """

    def __init__(self, parent):
        # initialize with type=1 to use QCompleter:
        super(CustomTagEdit, self).__init__(parent, type=1)
        self.tags = []
        self.setupValidator()

    def focusOutEvent(self, evt):
        QLineEdit.focusOutEvent(self, evt)

    def focusInEvent(self, evt):
        QLineEdit.focusInEvent(self, evt)

    def setTags(self, tags):
        self.tags = sorted(tags)
        self.enableCompletions()

    def disableCompletions(self):
        self.model.setStringList([])

    def enableCompletions(self):
        self.model.setStringList(self.tags)

    def setupValidator(self):
        """
        Initialize validator to prevent user from typing whitespace
        """
        self.validator = QRegExpValidator(QRegExp("[^\s]+"), self)
        self.setValidator(self.validator)


class FindAndReplaceTagsDialog(QDialog):
    """
    Find and Replace Tags Dialog

    A simple modal dialog inheriting from QDialog

    Arguments:
        browser {aqt.browser.Browser} -- Anki card browser instance
        find_tags {list} -- List of auto-completed tags in the find field
        repl_tags {list} -- List of auto-completed tags in the replace field

    Keyword Arguments:
        count {int} -- Number of selected notes at dialog invocation time
                       (default: {0})
        total {int} -- Number of notes in entire Anki collection
                       (default: {0})
        whole_tags {bool} -- Start with checked whole tags checkbox
                            (default: {True})
        ignore_case {bool} -- Start with checked ignore case checkbox
                              (default: {False})
        regex {bool} -- Start with checked regex checkbox
                        (default: {False})
        count {int} -- Number of selected notes in the browser
                       (default: {0})
    """

    def __init__(self, browser, find_tags, repl_tags, count=0, total=0,
                 whole_tags=True, ignore_case=False, regex=False):
        super(FindAndReplaceTagsDialog, self).__init__(parent=browser)
        # Initialize instance vars:
        self.browser = browser
        self.find_tags = find_tags
        self.repl_tags = repl_tags
        self.limit = bool(count)
        self.count = count
        self.total = total
        self.whole_tags = whole_tags
        self.ignore_case = ignore_case
        self.regex = regex
        # Set up UI from pre-generated UI form:
        self.form = findreplacetags.Ui_Dialog()
        self.form.setupUi(self)
        # Perform any subsequent setup steps:
        self.setupLineEdits()
        self.setupFonts()
        self.setupButtons()
        self.setupEvents()
        self.setupToggles()
        self.setupWarnings()
        restoreGeom(self, "findrepltags")
        self.setupFocus()

    def setupLineEdits(self):
        """
        Initialize custom tag edits and add them to their respective
        predefined layouts.
        """
        self.form.find = CustomTagEdit(self)
        self.form.replace = CustomTagEdit(self)
        self.form.replace.setTags(self.repl_tags)
        self.form.layoutFind.addWidget(self.form.find)
        self.form.layoutReplace.addWidget(self.form.replace)

    def setupFocus(self):
        """
        Set the find field to be focused on dialog invocation
        """
        self.form.find.setFocus()

    def setupFonts(self):
        """
        Prepare the different types of fonts that the find/replace
        fields use depending on the replacement mode
        """

        # There is no generalized monospace font that would work across
        # all platforms, so we have to hard-code it here for each platform:
        if isMac:
            monospace = "Monaco"
        elif isWin:
            monospace = "Courier"
        else:
            monospace = "Monospace"

        mono = QFont(monospace)
        # ensure that the font is presented monospaced:
        mono.setStyleHint(QFont.TypeWriter)

        palette = QPalette()
        palette.setColor(QPalette.Text, Qt.darkGreen)

        self.font_mono = mono
        self.palette_mono = palette
        self.font_regular = QApplication.font()
        self.palette_regular = QApplication.palette()

    def setupButtons(self):
        """
        Perform modifications to default QDialogButtonBox
        """
        support_btn = self.form.buttonBox.button(
            QDialogButtonBox.RestoreDefaults)
        support_btn.setText("❤ Support my work")
        support_btn.setFocusPolicy(Qt.ClickFocus)
        support_btn.clicked.connect(self.onSupportAddon)

    def setupEvents(self):
        """
        Set up events and triggers
        """
        self.form.regex.toggled.connect(self.onRegexToggle)
        self.form.limit.toggled.connect(self.onLimitToggle)
        self.form.ignoreCase.toggled.connect(self.onIgnoreCaseToggle)
        self.form.buttonBox.helpRequested.connect(self.onHelp)

    def setupToggles(self):
        """
        Set initial checkbox state
        """
        self.form.limit.setChecked(self.limit)
        self.form.limit.setEnabled(self.limit)
        self.form.wholeTags.setChecked(self.whole_tags)
        self.form.ignoreCase.setChecked(self.ignore_case)
        self.form.regex.setChecked(self.regex)

    def onLimitToggle(self, checked):
        """
        Perform UI changes when the limit checkbox is toggled

        Arguments:
            checked {boolean} -- Checkbox checked?
        """
        # Update performance warnings:
        self.setupWarnings()
        # Update auto-suggestions according to tag pool:
        if checked:
            self.form.find.setTags(self.find_tags)
        else:
            self.form.find.setTags(self.repl_tags)

    def onIgnoreCaseToggle(self, checked):
        """
        Perform UI changes when the ignore ase checkbox is toggled
        
        Arguments:
            checked {boolean} -- Checkbox checked?
        """
        self.setupWarnings()

    def onRegexToggle(self, checked):
        self.setupWarnings()
        # Toggle whole_tags, autocompletions, and find/replace field
        # font styling:
        if checked:
            self.form.wholeTags.setChecked(False)
            self.form.wholeTags.setEnabled(False)
            for tag_edit in (self.form.find, self.form.replace):
                tag_edit.disableCompletions()
                tag_edit.setFont(self.font_mono)
                tag_edit.setPalette(self.palette_mono)
        else:
            self.form.wholeTags.setEnabled(True)
            for tag_edit in (self.form.find, self.form.replace):
                tag_edit.enableCompletions()
                tag_edit.setFont(self.font_regular)
                tag_edit.setPalette(self.palette_regular)

    def setupWarnings(self):
        """
        Conditionally display performance warning label
        """
        ignore_case = self.form.ignoreCase.isChecked()
        if self.form.limit.isChecked():
            count = self.count
        else:
            count = self.total

        # Case-insensitive replacements are ≈14x slower. The values below
        # should warn users when the estimated completion time surpasses 5s
        if (ignore_case and count > 500) or (not ignore_case and count > 7000):
            self.form.perfWarning.show()
        else:
            self.form.perfWarning.hide()

    def onHelp(self):
        """
        Open add-on wiki in external browser
        """
        openLink(help_link)

    def onSupportAddon(self, checked):
        """
        Open page to contribute to add-on in external browser
        
        Arguments:
            checked {bool} -- Whether button is checked. Always emitted
                              for the clicked() signal.
        """
        openLink(support_author_link)

    def getInputs(self):
        """
        Parse current inputs and return them to the caller

        Returns:
            dict -- Dictionary of user inputs
        """
        return {
            "find": self.form.find.text().strip(),
            "replace": self.form.replace.text().strip(),
            "limit": self.form.limit.isChecked(),
            "whole_tags": self.form.wholeTags.isChecked(),
            "ignore_case": self.form.ignoreCase.isChecked(),
            "regex": self.form.regex.isChecked()
        }

    def reject(self):
        """
        Save window geometry before dismissing dialog
        """
        saveGeom(self, "findrepltags")
        super(FindAndReplaceTagsDialog, self).reject()

    def accept(self):
        """
        Save window geometry, perform sanity check on find/replace fields,
        inform user / ask them for confirmation in specific scenarios
        """
        saveGeom(self, "findrepltags")

        find = self.form.find.text()
        replace = self.form.replace.text()
        if not find:
            showWarning("'Find' field empty. Cannot perform replacement.")
            return
        elif find and not replace:
            c = askUser("<b>Info</b>: 'Replace' field empty. Do you want me to"
                        " delete the tags / subtags matching <b>{}</b> in all "
                        "pertinent notes?".format(find),
                        title="Please Confirm Action", parent=self)
            if not c:
                return

        super(FindAndReplaceTagsDialog, self).accept()
