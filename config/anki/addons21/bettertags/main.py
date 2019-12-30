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
Main Module, hooks add-on methods into Anki
"""

# Stdlib imports

from __future__ import unicode_literals

import os

# Anki imports

from aqt import mw
from aqt.browser import Browser
from aqt import tagedit
from aqt.utils import askUser, showInfo
from anki.hooks import addHook, wrap

# Module-level imports

from .browser import (onFindReplaceTags, doFindAndReplaceTags, onRefreshTags,
                      editorSaveThenRun, onResultListContextMenu, setupMenu,
                      setupMenuWrap, onUndoBefore, onUndoAfter)

from .sidebar import (mySetupTree, CustomCallbackItem,
                      regularUserTagTree, hierarchicalUserTagTree, onTagClick,
                      onTreeContext, onSidebarTagReplace, onSidebarTagDelete,
                      onSidebarTagReposition, onSidebarTagReplace21,
                      onSidebarTagDelete21, onSidebarTagReposition21,
                      onSidebarTagHotkey, getTagItemData,
                      onSidebarFilteredDeck)

from .tagedit import CustomTagCompleter, CustomTagEdit

from .consts import anki21
from .config import local_conf


# ADD-ON SETUP ###################

def uninstallHierarchicalTags(htags_path=None):
    """
    Delete old HTags version from add-on directory
    
    Keyword Arguments:
        htags_path {str} -- Path to HTags entry point file
                            on Anki 2.0 (default: {None})
    """
    if anki21:
        mw.addonManager.deleteAddon("1835859645")
        showInfo("Uninstall successful. Please restart Anki.")
    elif htags_path:
        mw.addonManager.onRem(htags_path)


def setupAddon():
    """
    Check if old version of HTags installed and prompt
    user to remove it.
    """
    if anki21:
        name = "1835859645"
    else:
        name = "HierarchicalTags.py"
    htags_path = os.path.join(mw.addonManager.addonsFolder(), name)

    if os.path.exists(htags_path):
        choice = askUser(
            "It seems like you still have an old version of the "
            "<i>Hierarchical Tags</i> add-on installed. "
            "<i>BetterTags</i> comes with its own enhanced "
            "revision of Hierarchical Tags.<br><br>"
            "In order for the add-on to work properly it is "
            "important that you remove the old version of "
            "<i>Hierarchical Tags </i> first."
            "<br><br><b>Would you like Anki to do this for you now?</b>",
            title="BetterTags Installation",
            parent=mw
        )
        if choice:
            uninstallHierarchicalTags(htags_path)


# PATCHES & HOOKS ###################

# BROWSER ###################

# Add our own methods to the Browser class, so that we can call them as
# instance methods, *and* modify existing methods with our own changes
Browser.onFindReplaceTags = onFindReplaceTags
Browser.doFindAndReplaceTags = doFindAndReplaceTags
Browser.onRefreshTags = onRefreshTags
Browser.onTreeContext = onTreeContext
Browser.CallbackItem = CustomCallbackItem
Browser.onTagClick = onTagClick
Browser.getTagItemData = getTagItemData
Browser.onSidebarTagHotkey = onSidebarTagHotkey
Browser.onSidebarFilteredDeck = onSidebarFilteredDeck
Browser.onUndoBefore = onUndoBefore
Browser.onUndoAfter = onUndoAfter

# Version-specific methods and changes
if anki21:
    Browser.setupSidebar = wrap(Browser.setupSidebar, mySetupTree, "around")
    Browser.editorSaveThenRun = editorSaveThenRun
    Browser.onContextMenu = onResultListContextMenu
    Browser.onSidebarTagReplace = onSidebarTagReplace21
    Browser.onSidebarTagDelete = onSidebarTagDelete21
    Browser.onSidebarTagReposition = onSidebarTagReposition21
    Browser._onSidebarTagReplace = onSidebarTagReplace
    Browser._onSidebarTagDelete = onSidebarTagDelete
    Browser._onSidebarTagReposition = onSidebarTagReposition
else:
    Browser.setupTree = wrap(Browser.setupTree, mySetupTree, "around")
    Browser.onSidebarTagReplace = onSidebarTagReplace
    Browser.onSidebarTagDelete = onSidebarTagDelete
    Browser.onSidebarTagReposition = onSidebarTagReposition

# Enable hierarchical tags
if local_conf["enableHierarchicalTags"]:
    Browser._userTagTree = hierarchicalUserTagTree
else:
    Browser._userTagTree = regularUserTagTree

# Need to use a wrap to change undo behavior
Browser.setupMenus = wrap(Browser.setupMenus, setupMenuWrap, "around")

# Add a hook to set up our custom menus after the default browser menus
# have been set up
addHook("browser.setupMenus", setupMenu)


# TAGEDIT ###################

# Conditionally patch the tagedit classes
if local_conf["enableHierarchicalCompleter"]:
    tagedit.TagEdit = CustomTagEdit
    tagedit.TagCompleter = CustomTagCompleter


# COMMON ###################

# Run remaining steps and checks of the add-on setup after all
# other add-ons have been loaded (i.e. once the profile is ready)
addHook("profileLoaded", setupAddon)
