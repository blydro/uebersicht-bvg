# Stop id from BVG API
STOP_ID = 900000066256
DIRECTION_NAME = "S+U Rathaus Steglitz"

url = "https://vbb.transport.rest/stations/#{STOP_ID}/departures?duration=45"

command: "curl -s '#{url}'"

refreshFrequency: 30000

getBus: (output, i) ->
  out = JSON.parse(output);

  dest = out[i].direction;
  time = out[i].when;

  timeUntil = @timeDiffMin(time);

  #console.log(timeUntil, time)

  generated = "Bus in <span class=\"time\">" + timeUntil + "</span> minutes"
  if timeUntil == 1
    generated = "Bus in <span class=\"time\">" + timeUntil + "</span> minute"
  if timeUntil == 0
    generated = "Bus <span class=\"time\">now</span>"

  if dest != DIRECTION_NAME
    generated = @getBus(output, i + 1)

  generated

formattedTimeFromTimestamp: (timestamp) ->
  date = new Date(timestamp)

  hours = ((if date.getHours() < 10 then "0" + date.getHours() else date.getHours()))
  minutes = ((if date.getMinutes() < 10 then "0" + date.getMinutes() else date.getMinutes()))
  [minutes, hours]

timeDiffMin: (time) ->
  date = new Date().getTime()
  timee = new Date(time).getTime()
  now = @formattedTimeFromTimestamp(date)
  thenn = @formattedTimeFromTimestamp(timee)
  minutesNow = now[0]
  minutesThen = thenn[0]

  if now[1] > thenn[1]
    minutesNow = minutesNow + 60
  if now[1] < thenn[1]
    minutesNow = minutesNow - 60

  final = minutesThen - minutesNow

  final

render: (out) ->
  @getBus(out, 0)
  
style: """
  // position on screen
  top: 125px;
  left: 30px;

  position: fixed;
  -webkit-font-smoothing: antialiased; // nicer font rendering
  color: #2e2e2e;

  font: 32pt "SF Pro Display", "Zilla Slab Highlight Regular", monospace;

  .time
    font: 32pt "SF Pro Display", "Zilla Slab Highlight Bold", monospace;
    font-weight: 600

"""
