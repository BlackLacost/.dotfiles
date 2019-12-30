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
Utility functions used to find and replace tags in the database
"""

from __future__ import unicode_literals

import re

from anki.utils import ids2str, intTime


def findReplaceTags(col, nids, src, dst, whole_tags=True,
                    ignore_case=False, regex=False):
    """
    Perform tag replacements on provided notes within Anki collection

    Arguments:
        col {anki.collection._Collection} -- Anki collection object
        nids {list} -- List of note IDs to iterate through. If empty
                       iterate through all notes in the collection.
        src {str} -- Original string
        dst {str} -- Replacement string

    Keyword Arguments:
        whole_tags {bool} -- Whether or not to match whole words instead of
                             substrings (default: {True})
        ignore_case {bool} -- Whether or not to ignore case (default: {True})
        regex {bool} -- Whether or not to treat src and dst as regular
                        expressions (default: {False})

    Returns:
        int -- Number of succesful replacements
    """

    # Sanity check
    if not src:
        print("No src string provided.")
        return False

    # Adjust regular expression according to supplied user settings
    # and compile it:
    if not regex:
        src = re.escape(src)

    if whole_tags:
        src = r"^" + src + r"$"

    if ignore_case:
        src = r"(?i)" + src

    re_compiled = re.compile(src)

    # Check and adjust note limits
    if nids:
        # query selected nids
        nids_string = ids2str(nids)
        query = "select id, tags from notes where id in " + nids_string
    else:
        # query entire collection
        query = "select id, tags from notes"

    # Walk through provided note IDs, query the database for the
    # corresponding tag strings, and compile a list of changes
    # to apply subsequently
    note_dicts = []
    updated_nids = []

    for nid, tags_string in col.db.execute(query):

        tags = col.tags.split(tags_string)

        new_tags = [re_compiled.sub(dst, tag) for tag in tags]

        new_tags_string = col.tags.join(customTagCanonify(col, new_tags,
                                                          ignore_case))

        if new_tags_string.strip() != tags_string.strip():
            updated_nids.append(nid)
            note_dicts.append(
                dict(nid=nid, tags=new_tags_string, u=col.usn(), m=intTime()))

    if not note_dicts:
        return 0

    # Commit previously registered changes to the database and update
    # caches / regenerate cards
    col.db.executemany(
        "update notes set tags=:tags,mod=:m,usn=:u where id=:nid", note_dicts)

    return len(note_dicts)


def customTagCanonify(col, tag_list, ignore_case):
    """
    Strip duplicates, adjust case to match existing tags if
    ignore_case set, and sort.

    Modified version of anki.tags.tagCanonify

    Arguments:
        col {anki.collection._Collection} -- Anki collection object
        tag_list {list} -- List of tags to canonify
        ignore_case {boolean} -- Whether or not to normalize case

    Returns:
        list -- List of canonified tags
    """
    if not ignore_case:
        stripped = [re.sub("[\"']", "", t) for t in tag_list if t]
    else:
        stripped = []
        for t in tag_list:
            if t == "":
                continue
            s = re.sub("[\"']", "", t)
            if ignore_case:
                for existing in col.tags.tags:
                    if s.lower() == existing.lower():
                        s = existing
            stripped.append(s)

    return sorted(set(stripped))


def getSearchString(tag, whole_tags):
    """
    Return query language search token for provided tag.

    Arguments:
        tag {str} -- Tag (component) to look for
        whole_tags {boolean} -- Whether 'tag' is a full tag or not

    Returns:
        str -- Query language search token
    """
    if not tag:
        return ""
    elif whole_tags:
        return '"tag:{}"'.format(tag)
    else:
        return '"tag:*{}*"'.format(tag)
