'use strict'

function formatTime(time) {
  var r = String(time)
  while (r.length < 2) {
    r = '0' + r
  }
  return r
}

var Info = {}

Info.getUrl = function () {
  return mp.get_property('path')
}

Info.getTimePosition = function () {
  return mp.get_property_number('time-pos')
}

Info.getTimeStamp = function (time) {
  var timePosition = time
  var time_seg = timePosition % 60
  timePosition -= time_seg
  var time_hours = Math.floor(timePosition / 3600)
  timePosition -= time_hours * 3600
  var time_minutes = timePosition / 60
  var time_ms = time_seg - Math.floor(time_seg)
  time_seg -= time_ms
  var timeMinSec =
    // formatTime(time_hours) +
    // ':' +
    formatTime(time_minutes + time_hours * 60) + ':' + formatTime(time_seg)
  //  +
  // '.' +
  // time_ms.toFixed(9).toString().split('.')[1]
  return timeMinSec
}

Info.getUrlWithTime = function (url, time) {
  return url + '#t=' + time
}

Info.getTimeStampWithUrl = function () {
  var url = Info.getUrl()
  var timePosition = Info.getTimePosition()
  var timeStamp = Info.getTimeStamp(timePosition)
  var result = Info.getLink(timeStamp, Info.getUrlWithTime(url, timePosition))
  return result
}

Info.getLink = function (title, url) {
  return '[' + title + '](' + url + ')'
}

module.exports = Info
