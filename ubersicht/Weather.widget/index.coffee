# ------------------------------ CONFIG ------------------------------

# openweathermap.org api key
apiKey: '462f91ab051cd00988c7ed87cb143c55'

# degree units; 'c' for celsius, 'f' for fahrenheit
unit: 'c'

# refresh every x minutes
refreshFrequency: 900000

# show Beaufort wind scale; true or false
windscale: false

# language; supported languages see https://openweathermap.org/current#multi
language: 'en'

latitude: 22.3286
longitude: 114.1603

# ---------------------------- END CONFIG ----------------------------

command: "echo {}"

makeCommand: (apiKey, lat, lon, language) ->
	"curl -s 'https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{apiKey}&lang=#{language}'"

render: (o) -> """
	<article id="content">
		<div id="icon">&#xf03e;</div>
		<div id="left">
			<div id="temp">00.0 - 00.0 °C</div>
			<div class="information">
				<span id="humidity">0%</span>
				<img class="droplet" src="Weather.widget/droplet.svg"></img>
				<span id="condition">unknown</span>
				<span id="windscale"></span>
			</div>
		</div>
	</article>
"""

afterRender: (domEl) ->
	if @apiKey.length != 32
		domEl.innerHTML = '<a href="https://openweathermap.org/appid" style="color: red">You need an API key!</a>'
		return

	# geolocation.getCurrentPosition (e) =>
	# 	coords     = e.position.coords
	# 	@command   = @makeCommand(@apiKey, coords.latitude, coords.longitude, @language)

	# 	@refresh()

	@command   = @makeCommand(@apiKey, @latitude, @longitude, @language)
	@refresh()

update: (o, dom) ->
	try
		data = JSON.parse(o)
		console.log(data)
	catch e
		return

	return unless data.main?

	t_min = @roundTo1Dp(@convertTempUnit(data.main.temp_min))
	t_max = @roundTo1Dp(@convertTempUnit(data.main.temp_max))
	temp_str = "#{t_min} - #{t_max} #{if @unit == 'c' then ' °C' else ' °F'}"

	$(dom).find('#temp').html(temp_str)
	$(dom).find('#humidity').html("#{data.main.humidity}%")
	$(dom).find('#condition').html("#{data.weather[0].description}")
	$(dom).find('#icon')[0].innerHTML = @getIcon(data.weather[0])

	if @windscale
		$(dom).find('#windscale')[0].innerHTML = @getWind(data.wind)

style: """
	width 25%
	left: 22px;
	top: 14px;
	font-family "Domaine Display Narrow"
	font-weight bold
	font-smooth always
	/* color #fff
	text-shadow 0px 0px 15px rgba(0, 0, 0, 0.3) */

	background: -webkit-linear-gradient(-80deg, #ff6933, #C70039 70%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;

	@font-face
		font-family Weather
		src url(Weather.widget/icons.svg) format('svg')

	#left
		padding-left 66px

	#temp
		font-size 2em

	#condition
		margin-left 0.6ch

	#icon
		margin-top -0.65%
		font-size 3em

	#windscale
		font-size 1.5em
		margin-left 1%
		margin-top -1.5%

	#icon, #windscale
		vertical-align middle
		float left
		font-family Weather

	.information
		display flex
		letter-spacing 0.5px
		font-weight 400
		font-size 1em

	.droplet
		height 1em
		margin-top -0.5%
"""

iconMapping:
	"unknown" :"&#xf03e;"
	"01d"     :"&#xf00d;"
	"01n"     :"&#xf02e;"
	"02d"     :"&#xf00c;"
	"02n"     :"&#xf081;"
	"03d"     :"&#xf002;"
	"03n"     :"&#xf031;"
	"04d"     :"&#xf013;"
	"04n"     :"&#xf013;"
	"09d"     :"&#xf01a;"
	"09n"     :"&#xf01a;"
	"10d"     :"&#xf019;"
	"10n"     :"&#xf019;"
	"11d"     :"&#xf01e;"
	"11n"     :"&#xf01e;"
	"13d"     :"&#xf01b;"
	"13n"     :"&#xf01b;"
	"50d"     :"&#xf003;"
	"50n"     :"&#xf04a;"
	"wind3"   :"&#xf0ba;"
	"wind4"   :"&#xf0bb;"
	"wind5"   :"&#xf0bc;"
	"wind6"   :"&#xf0bd;"
	"wind7"   :"&#xf0be;"
	"wind8"   :"&#xf0bf;"
	"wind9"   :"&#xf0c0;"
	"wind10"  :"&#xf0c1;"
	"wind11"  :"&#xf0c2;"
	"wind12"  :"&#xf0c3;"
	"none"    :""

getIcon: (data) ->
		return @iconMapping['unknown'] unless data
		@iconMapping[data.icon]

getWind: (data) ->
		if data.speed > 32.7
			@iconMapping["wind12"]
		else if data.speed > 28.5
			@iconMapping["wind11"]
		else if data.speed > 24.5
			@iconMapping["wind10"]
		else if data.speed > 20.8
			@iconMapping["wind9"]
		else if data.speed > 17.2
			@iconMapping["wind8"]
		else if data.speed > 13.9
			@iconMapping["wind7"]
		else if data.speed > 10.8
			@iconMapping["wind6"]
		else if data.speed > 8
			@iconMapping["wind5"]
		else if data.speed > 5.5
			@iconMapping["wind4"]
		else if data.speed > 3.4
			@iconMapping["wind3"]
		else
			@iconMapping["none"]

convertTempUnit: (temp) ->
	if @unit == 'f'
		(temp - 273.15) * 9 / 5 + 32
	else
		temp - 273.15

roundTo1Dp: (n) ->
	Math.round((n + Number.EPSILON) * 10) / 10