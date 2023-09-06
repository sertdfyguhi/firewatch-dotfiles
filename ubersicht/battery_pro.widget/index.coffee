#-----------------------------------------------------------------------#
#																		#
# Battery Pro for Übersicht 											#
# 																		#
# Created July 2018 by Mike Pennella (github.com/mpen01/battery_pro)	#
#																		#
# THEME & STYLE OPTIONS													#
# Change the variables below to change the appearance of the widget		#
theme		= 'color'	# mono, paper, color or dark (default is color)	#
style		= 'full'	# mini or full	(default is full)				#
#																		#
# LOW POWER THRESHHOLD													#
# Battery indicators turn red if battery is discharging and				#
# below this number.  Default is 20%, you may want it higher or lower	#
lowPower	= 20														#
#																		#
# POSITION WIDGET ON SCREEN												#
pos1	= 'right: 1.6rem'													#
pos2	= 'bottom: 8.25rem'													#
#																		#
#-----------------------------------------------------------------------#

labelColor			= 'WHITE'
opacityLevel		= '1'

if theme == 'mono' || theme == 'dark'
  statusColor		= 'WHITE'
  chargingColor		= 'WHITE'
  dischargeColor	= 'WHITE'
  lowPowerColor		= 'WHITE'
  lineColor			= 'WHITE'
  bkground			= 'rgba(#000, 0.0)'
  fullCharge		= "battery_pro.widget/icons/white_full_charge.png"
  almostFullCharge	= "battery_pro.widget/icons/white_almost_charged.png"
  halfCharged		= "battery_pro.widget/icons/white_half_charged.png"
  lowCharge			= "battery_pro.widget/icons/low-battery.png"
  batteryCharging	= "battery_pro.widget/icons/white_charging.png"
  batteryCharged	= "battery_pro.widget/icons/white_full_charge.png"
  
else if theme == 'paper'
  statusColor		= 'BLACK'
  chargingColor		= 'BLACK'
  dischargeColor	= 'BLACK'
  lowPowerColor		= 'BLACK'
  lineColor			= 'WHITE'
  bkground			= 'rgba(#fff, 1)'
  fullCharge		= "battery_pro.widget/icons/black_full_charge.png"
  almostFullCharge	= "battery_pro.widget/icons/black_almost_charged.png"
  halfCharged		= "battery_pro.widget/icons/black_half_charged.png"
  lowCharge			= "battery_pro.widget/icons/low-battery.png"
  batteryCharging	= "battery_pro.widget/icons/black_charging.png"
  batteryCharged	= "battery_pro.widget/icons/black_full_charge.png"
  
else
  statusColor		= '#D3D3D3'   # Grey
  chargingColor		= '#7dff7d'   # Bright Green
  dischargeColor	= 'WHITE'
  lowPowerColor		= '#FF0000'   # Red
  lineColor			= 'rgba(51, 51, 51, 0.3)'	  # Blue
  bkground			= 'rgba(33, 33, 33, 0.45)'
  fullCharge		= "battery_pro.widget/icons/full_charge.png"
  almostFullCharge	= "battery_pro.widget/icons/almost_charged.png"
  halfCharged		= "battery_pro.widget/icons/half_charged.png"
  lowCharge			= "battery_pro.widget/icons/low-battery.png"
  batteryCharging	= "battery_pro.widget/icons/white_charging.png"
  batteryCharged	= "battery_pro.widget/icons/blue_charged.png"
  
if theme == 'dark'
   bkground			= 'rgba(#000000)'
   lineColor		= 'rgba(#000000, 0.8)'
   opacityLevel		= '0.6'
   
if style == 'mini'
   labelColor		= 'rgba(#000, 0.0)' 
   statusColor		= 'rgba(#000, 0.0)'  
   lineColor		= 'rgba(#000, 0.0)' 
   bkground			= 'rgba(#000, 0.0)'

command: "pmset -g batt | grep -o '[0-9]*%; [a-z]*'"

# Refresh the widget every 10 seconds
refreshFrequency: 10000

style: """
#{pos1}
#{pos2}
font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto",
  "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
  sans-serif

.container
  display: flex

  border: 1px solid #{lineColor}
  border-radius: 6px

  background: #{bkground}
  backdrop-filter: blur(5px)
  -webkit-backdrop-filter: blur(5px)
  box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.4)

  font-size: 16px
  font-weight: 400

  opacity: #{opacityLevel}
  padding: 5px 10px 6px 7px

.text-container
  margin-top: 3px

.percent
  font-size: 18px
  font-weight: 500
  margin: 0

img
  height: 40px
  width: 40px

  margin: 0 -3px

.status
  padding: 0
  margin: 0
  margin-top: -2px

  font-size: 12px
  font-weight: 400

  max-width: 100%

  color: #{statusColor}
  text-overflow: ellipsis
  text-shadow: none
"""


render: -> """
  <div class="container">
    <img id="batt_icon" src=fullCharge>
    <div class="text-container">
      <p class='percent'></p>
      <p class='status'></p>
    </div>
  </div>
"""

update: (output, domEl) ->
  values	= output.split(";")
  percent	= values[0]

  status = values[1].trim()
  # captialize status and add period
  if status.length > 0
    status = status[0].toUpperCase() + status.slice(1) + '.'

  div = $(domEl)

  if status == "discharging"
    battery = parseInt(percent.substring(0, percent.length - 1))

    if battery <= lowPower
      div.find('.percent').html(percent.fontcolor(lowPowerColor)) 
      status = 'Low power. Plug in soon.'
      document.getElementById("batt_icon").src = lowCharge
    else
      div.find('.percent').html(percent.fontcolor(dischargeColor)) 

      if battery >= 90
        document.getElementById("batt_icon").src = fullCharge
      else if battery > 60
        document.getElementById("batt_icon").src = almostFullCharge
      else if battery > 20
        document.getElementById("batt_icon").src = halfCharged
  else
    document.getElementById("batt_icon").src = batteryCharging
    div.find('.percent').html(percent.fontcolor(chargingColor))

    if status.length == 0
      status = 'Cable attached.'

  div.find('.status').html(status)