# Developed by Virej Dasani
# My website: https://virejdasani.github.io/virej/
# GitHub: https://github.com/virejdasani/
# Luminous Time on GitHub: https://github.com/virejdasani/LuminousTime

command: "finger `whoami` | awk -F: '{ print $3 }' | head -n1 | sed 's/^ // '"

# Refresh time every 10 seconds
refreshFrequency: 5000

# Body Style
style: """
font-family: "Domaine Display Narrow"

.container
  position: fixed
  top: 25%
  left: 50%
  transform: translate(-50%, -50%)

  width: 800px
  height: auto

  text-align: center
  font-weight: medium

  /* background: -webkit-linear-gradient(-60deg, #ff78df, #ffa41c 87%); */
  background: -webkit-linear-gradient(-80deg, #ff6933, #C70039 70%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;

  /* -webkit-filter: drop-shadow(0px 0px 15px rgba(0, 0, 0, 0.1)) */

.time
  font-weight: 500
  text-align: center

.amPm
  font-size: 1.5em
  margin-right: -1%

.salutation
  font-size: 2.8em
  font-weight: medium

  margin-top: -2%

.hour
  font-size: 10em
  margin-right: -0.4%

.seperator
  font-size: 8.5em
  font-weight: 100
  vertical-align: top

.min
  font-size: 8.5em
"""
render: -> """
  <div class="container">
    <div class="time">
      <span class="hour"></span>
      <span class="seperator">:</span>
      <span class="min"></span>
      <span class="amPm"></span>
    </div>
    <p class="salutation"></p>
  </div>
"""

# Update function
update: (output, domEl) ->
  # Prefs
  showAmPm = true;

  # Time Segmends for the day
  segments = ["morning", "afternoon", "evening", "night"]

  # To change, make name = "your name"
  # name = output.split(' ')
  name = "Jonas"

  # Creating a new Date object
  today = new Date()
  hour = today.getHours()
  minutes = today.getMinutes()
  dayNum = today.getUTCDay()
  monthNum = today.getMonth() + 1

  day = "Mon" if (dayNum = 1)

  date = day

  # Quick and dirty fix for single digit minutes
  minutes = "0" + minutes if minutes < 10

  if 4 < hour <= 11
    timeSegment = segments[0]
  else if 11 < hour <= 17
    timeSegment = segments[1]
  else if 17 < hour <= 24
    timeSegment = segments[2]
  else
    timeSegment = segments[3]

  #AM/PM String logic
  amPm = if hour < 12 then "AM" else "PM"

  # 0 Hour fix
  hour = 12 if hour == 0;

  # 24 - 12 Hour conversion
  hour = hour % 12 if hour > 12

  # DOM manipulation
  $(domEl).find('.salutation').text("Good #{timeSegment}, #{name}.")
  $(domEl).find('.hour').text("#{hour}")
  $(domEl).find('.min').text("#{minutes}")
  $(domEl).find('.amPm').text("#{amPm}") if showAmPm
  $(domEl).find('.date').text("#{date}")