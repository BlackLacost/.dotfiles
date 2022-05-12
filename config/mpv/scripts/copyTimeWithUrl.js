function getUrl() {
  return mp.get_property('path')
}

function getTimePosition() {
  return mp.get_property_number('time-pos')
}

function setClipboard(text) {
  mp.commandv('run', 'powershell', 'set-clipboard "' + text + '"')
}

function formatTime(time) {
  var r = String(time)
  while (r.length < 2) {
    r = '0' + r
  }
  return r
}

function getTimeStamp(timePosition) {
  var time_seg = timePosition % 60
  timePosition -= time_seg
  var time_hours = Math.floor(timePosition / 3600)
  timePosition -= time_hours * 3600
  var time_minutes = timePosition / 60
  var time_ms = time_seg - Math.floor(time_seg)
  time_seg -= time_ms
  var time =
    // formatTime(time_hours) +
    // ':' +
    formatTime(time_minutes + time_hours * 60) + ':' + formatTime(time_seg)
  //  +
  // '.' +
  // time_ms.toFixed(9).toString().split('.')[1]
  return '[' + time + ']'
}

function copyTimeWithUrl() {
  var url = getUrl()
  var timePosition = getTimePosition()
  var timeStamp = getTimeStamp(timePosition)
  var result = timeStamp + '(' + url + '#t=' + timePosition + ')'
  setClipboard(result)
  mp.osd_message('Copied to Clipboard: ' + result)
}

mp.add_key_binding('', 'copyTimeWithUrl', copyTimeWithUrl)
