'use strict'

var Clipboard = {}

Clipboard.set = function (text) {
  // var validText = text.replace(/"/g, "'")
  var validText = text.replace(/&/g, '').replace(/"/g, '')
  mp.commandv('run', 'powershell', 'set-clipboard "' + validText + '"')
}

Clipboard.setWithMessage = function (text) {
  Clipboard.set(text)
  mp.osd_message('Copied to Clipboard: ' + text)
}

module.exports = Clipboard
