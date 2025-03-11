'use strict'

var Clipboard = require('./modules/clipboard')
var Info = require('./modules/info')

function main() {
  Clipboard.setWithMessage(Info.getTimeStampWithUrl())
}

mp.add_key_binding('', 'copyTimeWithUrl', main)
