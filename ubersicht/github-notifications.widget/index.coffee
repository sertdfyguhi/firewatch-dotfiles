user          = '<your github username>'
apiKey        = '<personal access api key with notification access>'
publicApi     = 'https://api.github.com'
enterpriseApi = '<your github enterprise api url here>'
enterprise    = false
proxyUrl      = '<your https proxy url string here>'
proxy         = false

api = if enterprise then enterpriseApi else publicApi

proxyCmd = if proxy then "-x #{proxyUrl}" else ""

cmd = "curl -s --user #{user}:#{apiKey} -s #{api}/notifications #{proxyCmd}"

command: cmd

enterprise: enterprise

refreshFrequency: 600000

style: """
  top: 50%;
  left: 22px;
  transform: translateY(-55%);

  a:link, a:visited, a:hover, a:active {
    color: #000
  }

  .github-notifications {
    display: flex;
    flex-direction: column;
    gap: 14px;

    border-radius: 10px;
    border: 1px solid rgba(51, 51, 51, 0.4);
    padding: 14px 10px;
    color: #E5E5E5;
    background-color: rgba(42, 44, 46, 0.7);
    -webkit-backdrop-filter: blur(5px)

    box-shadow: 0px 0px 17px rgba(0, 0, 0, 0.3);
  }

  .enterprise {
    color: #E5E5E5;
    background-color: #2A2C2E;
  }

  @font-face {
    font-family: 'octicons';
    src: url('github-notifications.widget/octicons/octicons.eot?#iefix') format('embedded-opentype'),
         url('github-notifications.widget/octicons/octicons.woff') format('woff'),
         url('github-notifications.widget/octicons/octicons.ttf') format('truetype'),
         url('github-notifications.widget/octicons/octicons.svg#octicons') format('svg');
    font-weight: normal;
    font-style: normal;
  }

  .octicon {
    font: normal normal normal 24px octicons;
    display: inline-block;
    text-decoration: none;
    text-rendering: auto;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }

  sub {
    line-height: 0;
    bottom: -0.25em;
  }

  .count-group {
    width: 40x;
    font-size: 24px;
    text-align: center;
    text-shadow: 0px 0px 10px rgba(255, 255, 255 0.25)
  }

  .count {
    font-size: 9px;
    background-color: red;
    border-radius: 10px;
    padding: 3px 5px;
    margin-left: -5px;
  }

  .public .count {
    color: #FFF;
  }
"""

iconMapping: [
  ["mention"     ,"&#xf0be;"],
  ["author"      ,"&#xf018;"],
  ["team_mention","&#xf037;"],
  ["assign"      ,"&#xf035;"]
  ["manual"      ,"&#xf077;"],
  ["comment"     ,"&#xf02b;"],
  ["subscribed"  ,"&#xf04e;"],
  ["state_change","&#xf0ac;"],
]

render: (output) -> @getVisual output

update: (output, domEl) ->
  $domEl = $(domEl)
  $domEl.html @getVisual output

getVisual: (output) ->
  data = []
  try
    data = JSON.parse output
  catch ex
    return """
      <div class='github-notifications #{if @enterprise then "enterprise" else "public"}'>
        <span>Error Retrieving Notifications!</span>
      </div>
    """

  counts =
    subscribed: 0
    manual: 0
    author: 0
    comment: 0
    mention: 0
    team_mention: 0
    state_change: 0
    assign: 0

  for reason in (notification.reason for notification in data)
    counts[reason] += 1

  icons = []

  for icon in @iconMapping
    count =
      if counts[icon[0]] > 0
        count = "<sub><span class='count'>#{counts[icon[0]]}</span></sub>"
      else
        ''
    icons.push "<div class='count-group'><span class='octicon'>#{icon[1]}</span>#{count}</div>"

  return """
    <a href='https://www.github.com/' + @user'>
      <div class='github-notifications #{if @enterprise then "enterprise" else "public"}'>
        #{icons.join('')}
      </div>
    </a>
  """
