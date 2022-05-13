'use strict'

var Clipboard = require('./modules/clipboard')

function main() {
  var subText =
    mp.get_property('sub-text').replace(/\n/g, ' ') + ' '.replace(/"/g, "'")
  Clipboard.setWithMessage(subText)
}

mp.add_key_binding('', 'copySub', main)
