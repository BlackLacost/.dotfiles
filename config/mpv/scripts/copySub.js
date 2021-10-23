function setClipboard(text) {
  mp.commandv('run', 'powershell', 'set-clipboard "' + text + '"')
}

function copySub() {
  var sub_text = mp
    .get_property('sub-text')
    .replace(/\n/g, ' ')
    .replace(/"/g, "'")
  setClipboard(sub_text)
  mp.osd_message('Copied to Clipboard: ' + sub_text)
}

mp.add_key_binding('', 'copySub', copySub)
