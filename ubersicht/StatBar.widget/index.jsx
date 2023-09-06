import { css, run, React } from 'uebersicht';
import * as config from './config.json';

export const refreshFrequency = 50000;

// get the current screen resolution
const screenWidth = window.screen.width;
const barWidth = screenWidth - 40;

const options = {
  bottom: '3.7rem',
  left: '50%',
  // width: barWidth + 'px',
  width: 'fit-content',

  // Refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  timezone: 'Asia/Hong_Kong',
  city: 'Hong Kong',

  disk: '/dev/disk3s5', // the disk to monitor

  useColor: true,
};

let lastWeatherUpdate = 0;
let weatherFetched = false;

export const command = dispatch => {
  run(
    'StatBar.widget/mini-bar-stats.sh ' + options.timezone + ' ' + options.disk
  ).then(output => {
    // parse the output as JSON
    const stats = JSON.parse(output);
    dispatch({
      type: 'UPDATE_STATS',
      data: stats,
    });
  });

  const now = Date.now();
  if (now - lastWeatherUpdate >= 1200000 || !weatherFetched) {
    lastWeatherUpdate = Date.now();

    fetch(
      `https://api.openweathermap.org/data/2.5/weather?q=${options.city}&units=metric&appid=${config.OPENWEATHERMAP_APIKEY}`
    )
      .then(response => {
        return response.json();
      })
      .then(data => {
        return dispatch({
          type: 'WEATHER_UPDATE',
          data: {
            weather: {
              temp: data.main.temp.toFixed(0),
              forecast: data.weather[0].main,
            },
          },
        });
      })
      .catch(() => {
        return dispatch({
          type: 'WEATHER_UPDATE',
          data: {
            weather: {
              temp: '...',
              forecast: '...',
            },
          },
        });
      });
  }
};

export const className = {
  bottom: options.bottom,
  left: options.left,
  transform: 'translateX(-50%)',

  width: options.width,
  userSelect: 'none',

  backgroundColor: 'rgba(42, 44, 46, 0.45)',
  '-webkit-backdrop-filter': 'blur(5px)',
  'box-shadow': '0px 0px 14px rgba(0, 0, 0, 0.3)',
  border: '1px solid rgba(51, 51, 51, 0.3)',

  // border: "1px solid #333",
  padding: '6px 17px',
  boxSizing: 'border-box',
  borderRadius: '9px',
};

const containerClassName = css({
  color: 'rgba(255, 255, 255)',
  fontFamily:
    'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif',
  fontSize: '13px',
  textAlign: 'center',
});

let red,
  green,
  blue,
  yellow,
  orange = '';

if (options.useColor) {
  red = css({
    '--color': '248, 179, 183',
  });

  green = css({
    '--color': '213, 241, 96',
  });

  blue = css({
    '--color': '137, 207, 240',
  });

  yellow = css({
    '--color': '246, 205, 103',
  });

  orange = css({
    '--color': '255, 87, 51',
  });
}

const metricStyle = css({
  display: 'inline-block',
  border: '1px solid rgba(23, 23, 23, 0.25)',
  padding: '3px 10px',
  borderRadius: '5px',
  backgroundColor: 'rgba(32, 32, 32, 0.2)',
  // add a shadow
  boxShadow: '0 0 10px rgba(0, 0, 0, 0.35)',
});

const metricsStyle = css({
  display: 'flex',
  flexDirection: 'row',
  justifyContent: 'center',
  gap: '10px',
});

const metricsStyleRow = css({
  display: 'flex',
  flexDirection: 'row',
  justifyContent: 'center',
  gap: '10px',
});

const verticalSeparator = css({
  display: 'inline-block',
  width: '1px',
  height: '10px',
  backgroundColor: '#36454F',
});

const icon = css({
  color: 'rgb(var(--color))',
  textShadow: '0px 0px 6px rgba(var(--color), 0.6)',
});

export const initialState = {
  day: '...',
  month: '...',
  dayNum: '...',
  year: '...',
  time: '...',
  ampm: '...',
  cpuUsage: 0,
  memoryUsage: 0,
  disk: 0,
  ethernet: 'N/A',
  wifi: {
    ssid: 'N/A',
    ip: 'N/A',
  },
  weather: {
    temp: '...',
    forecast: '...',
  },
};

export const updateState = (event, previousState) => {
  if (event.error)
    return { ...previousState, warning: `We got an error: ${event.error}` };

  if (event.type === 'UPDATE_STATS') {
    return {
      ...previousState,
      day: event.data.date_day,
      month: event.data.date_month,
      dayNum: event.data.date_day_num,
      year: event.data.date_year,
      time: event.data.date_time,
      ampm: event.data.date_ampm.toLowerCase(),
      cpuUsage: parseFloat(event.data.cpu_usage).toFixed(2),
      memoryUsage: parseFloat(event.data.mem_usage).toFixed(0),
      disk: event.data.disk_usage,
      ethernet: event.data.eth_ip,
      wifi: {
        ssid: event.data.ssid,
        ip: event.data.wifi_ip,
      },
    };
  }

  if (event.type === 'WEATHER_UPDATE') {
    weatherFetched = true;
    return {
      ...previousState,
      weather: event.data.weather,
    };
  }

  return {
    ...previousState,
    warning: false,
  };
};

export const render = ({
  warning,
  day,
  month,
  dayNum,
  year,
  time,
  ampm,
  cpuUsage,
  memoryUsage,
  ethernet,
  wifi,
  disk,
  weather,
}) => {
  if (warning) {
    return <div>{warning}</div>;
  }
  return (
    <div className={containerClassName}>
      <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css"
        integrity="sha512-+4zCK9k+qNFUR5X+cKL9EIR+ZOhtIloNl9GIKS57V1MyNsYpYcUrUeQc9vNfzsWfV28IaLL3i96P9sdNyeRssA=="
        crossOrigin="anonymous"
      />
      <div className={metricsStyle}>
        <div className={metricsStyleRow}>
          <div className={metricStyle}>
            <i className={`${icon} far fa-clock ${green}`}></i> {time}
            {ampm}
          </div>
          <div className={`${metricStyle}`}>
            <i className={`${icon} far fa-calendar ${yellow}`}></i> {day},{' '}
            {month} {dayNum} {year}
          </div>
          <div className={metricStyle}>
            <i className={`${icon} fas fa-thermometer-half ${orange}`}></i>{' '}
            {weather.temp}
            &deg;C
          </div>
          <div className={metricStyle}>
            <i className={`${icon} fa fa-cloud`}></i> {weather.forecast}
          </div>
          <div className={metricStyle}>
            <i className={`${icon} fas fa-microchip ${blue}`}></i> {cpuUsage}%
          </div>
          <div className={metricStyle}>
            <i className={`${icon} fas fa-memory ${green}`}></i> {memoryUsage}%
          </div>
          <div className={metricStyle}>
            <i className={`${icon} fas fa-hdd ${red}`}></i> {disk}%
          </div>
          <div className={metricStyle}>
            <i className={`${icon} fas fa-wifi ${blue}`}></i>
            {wifi.ssid === '' ? (
              ' N/A'
            ) : (
              <>
                {' '}
                {wifi.ssid} <div className={verticalSeparator}></div> {wifi.ip}
              </>
            )}
          </div>
          <div className={metricStyle}>
            <i className={`${icon} fas fa-ethernet ${blue}`}></i>
            {ethernet === '' ? ' N/A' : <> {ethernet}</>}
          </div>
        </div>
      </div>
    </div>
  );
};
