'use strict'

var Clipboard = require('./modules/clipboard')
var Info = require('./modules/info')

function getCurrentChapterTitle() {
  return JSON.parse(mp.get_property('chapter-metadata')).title
}

function getChapterList() {
  return JSON.parse(mp.get_property('chapter-list'))
}

function main() {
  var currentChapterTitle = getCurrentChapterTitle()
  var chapterList = getChapterList()
  var chapter = chapterList.filter(function (chapter) {
    return chapter.title === currentChapterTitle
  })[0]
  var time = chapter.time
  var title = chapter.title
  var urlWithTime = Info.getUrlWithTime(Info.getUrl(), time)
  var chapterLink = Info.getLink(title, urlWithTime)

  Clipboard.setWithMessage(JSON.stringify(chapterLink))
}

mp.add_key_binding('', 'copyChapter', main)
