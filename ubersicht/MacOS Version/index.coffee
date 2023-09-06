###
------------------------------------------------------------------------
  Name:         macos.version.and.uptime.widget
  Description:  Shows macOS Version and Up-Time for Übersicht
  Created:      18.Apr.2022
  Author:       Fjord Enzo
  Version:      4.0
  History:      4.0 Extended for Newer versions of macOS
  					Changed to CoffeeScript
  					Added new icons
  Based on:
   OS Version Pro for Übersicht
   By Mike Pennella
   https://github.com/mpen01/os-version-pro
------------------------------------------------------------------------
###

# Change the theme variable below to style the widget
# THEME OPTIONS: mono, paper, color, dark

# theme = 'mono'
# theme = 'paper'
# theme = 'color'
theme = 'dark'
#-----------------------------------------------------------------------

# Show or hide the version build information in the widget
showBuild = true
# const showBuild  = false
#-----------------------------------------------------------------------

# Position the widget on the screen
pos1  = 'right: 1.5rem'
pos2  = 'bottom: 3.6rem'
#-----------------------------------------------------------------------

# --- Create the themes ------------------------------------------------
if theme == 'mono' or theme == 'dark'
  labelColor   = '#fff'    # white
  nameColor    = '#fff'    # white
  osColor      = '#fff'    # white
  lineColor    = 'rgba(51, 51, 51, 0.3)'    # white
  uptimeColor  = '#ddd'    # light gray
  bkGround     = 'rgba(33, 33, 33, 0.45)'
  opacityLevel = '1'

else if theme == 'paper'
  labelColor   = '#fff'    # white
  nameColor    = '#000'    # black
  osColor      = '#000'    # black
  lineColor    = '#fff'    # white
  uptimeColor  = '#aaa'    # gray
  bkGround     = 'rgba(255, 255, 255, 1)'
  opacityLevel = '0.8'

else # theme = color
  labelColor   = '#fff'    # white
  nameColor    = '#fff' # orange #ffa640
  osColor      = '#7dff7d' # light green
  lineColor    = '#00bfff' # light blue
  uptimeColor  = '#ddd' # red e6273d
  bkGround     = 'rgba(0, 0, 0, 0.2)'
  opacityLevel = '1'

if theme == 'dark'
  uptimeColor  = '#aaa'    # gray
  lineColor    = 'rgba(0, 0, 0, 0.6)'
#-----------------------------------------------------------------------

# --- Collect the data -------------------------------------------------
#noinspection JSUnusedGlobalSymbols
command: "MacOS\\ Version/data.sh"

# --- Set the refresh frequency ----------------------------------------
refreshFrequency: '1m'

# --- render the widget ------------------------------------------------
render: -> """
  <div>
    <div class="osIcon"></div>
    <span class="osName"></span><span class="osRelease"></span>
    <p class="osVersion"></p>
    <p class="uptime"></p>
  </div>
"""

# --- Prepare the data to be rendered ----------------------------------
update: (output,domEl) ->
  [UP_Time, OS_Version, Interface] = output.split(/\r\n|\r|\n/g)

  # --- Create the up-time string --------------------------------------
  [d, dd, h, hh, m, mm] = UP_Time.split(" ")
  h  = if h  then h  else ''
  hh = if hh then hh else ''
  m  = if m  then m  else ''
  mm = if mm then mm else ''
  uptime = d + ' ' + dd + ' ' + h + ' ' + hh + ' ' + m + ' ' + mm

  # --- Create the OS information --------------------------------------
  [osName, osVersion, osBuild] = OS_Version.split(" ")
  iconDir = 'MacOS Version/icons/'

  icon = ''; osRelease = ''
  macOSVersion = parseInt( osVersion, 10 )
  if (macOSVersion >= 13.0 && macOSVersion < 14)
      if Interface == 'Dark' then icon = iconDir + "ventura.png" else icon = iconDir + "ventura.png"
      osRelease = ' Ventura'
  else if (macOSVersion >= 12.0 && macOSVersion < 13)
      if Interface == 'Dark' then icon = iconDir + "monterey-dark.png" else icon = iconDir + "monterey.png"
      osRelease = ' Monterey'
  else if (macOSVersion >= 11.0 && macOSVersion < 12.0)
      if Interface == 'Dark' then icon = iconDir + "big_sur.png" else icon = iconDir + "big_sur.png"
      osRelease = ' Big Sur'
  else if (macOSVersion >= 10.15 && macOSVersion < 10.16)
      if Interface == 'Dark' then icon = iconDir + "catalina_dark.png" else icon = iconDir + "catalina.png"
      osRelease = ' Catalina'
  else if (macOSVersion >= 10.14 && macOSVersion < 10.15)
      if Interface == 'Dark' then icon = iconDir + "mojave_dark.png" else icon = iconDir + "mojave.png"
      osRelease = ' Mojave'
  else if (macOSVersion >= 10.13  && macOSVersion < 10.14)
      icon = iconDir + "high_sierra.png"
      osRelease = ' High Sierra'
  else if (macOSVersion >= 10.12 && macOSVersion < 10.13)
      icon = iconDir + "sierra.png"
      osRelease = ' Sierra'
  else if (macOSVersion >= 10.11 && macOSVersion < 10.12)
      icon = iconDir + "el_capitan.png"
      osRelease = ' El Capitan'
  else if (macOSVersion >= 10.10 && macOSVersion < 10.11)
      icon = iconDir + "yosemite.png"
      osRelease = ' Yosemite'
  else
      icon = iconDir + "mac_os.png"

  # --- Preparing the dom-elements for replacement ---------------------
  dom = $(domEl)
  dom.find('.osIcon').replaceWith('<img src="' + icon + '" />')

  if osName == 'OSX'
    osName = osName.substr(0,2) + " " + osName.substr(2,1)

  if osName != ''
    dom.find('.osName').html(osName)
    dom.find('.osRelease').html(osRelease)
    if showBuild == true
      dom.find('.osVersion').html('Version ' + osVersion + ' ' + osBuild)
    else
      dom.find('.osVersion').html('Version ' + osVersion)
  else
    dom.find('.osVersion').html('OS info is not available')

  dom.find('.uptime').html(uptime)

# --- Widget styles ----------------------------------------------------
style: """
  #{pos1}
  #{pos2}
  font-family system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto",
    "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
    sans-serif
  color #{uptimeColor}

  div
    font-size 1rem
    font-weight 400
    display block
    border 0px solid #{lineColor}
    border-radius .5rem
    text-shadow 0 0 1px #{bkGround}
    box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.4)

    background #{bkGround}
    backdrop-filter: blur(5px)
    -webkit-backdrop-filter: blur(5px)

    opacity #{opacityLevel}
    padding 8px 10px 12px 7px

    &:after
      content ''
      position absolute
      left 0
      top -14px
      font-size .7rem
      font-weight 500
      color #{labelColor}

  .osName
    color #{osColor}
    font-size 1rem
    font-weight 600
    margin-left 0px
    margin-top 1px

  .osRelease
    font-size 1rem
    font-weight 400
    color #{osColor}
    margin 1px

  img
    height 50px
    width 50px
    margin-bottom -34px

  .osVersion, .uptime
    padding 0
    margin 0
    margin-left 55px
    font-size .65rem
    font-weight 400
    max-width 100%
    color #{nameColor}
    text-overflow ellipsis
    text-shadow none

  .uptime
    color #{uptimeColor}
    font-size: .7rem
    margin-top 1px
	font-weight: 400
	text-shadow: none
	padding: 0
	margin: 0 0 0 53px
	max-width: 100%

"""
