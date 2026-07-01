import QtQuick
import Quickshell.Io

Item {
	id: weatherData

	// Current conditions
	property real temperature: 0       // °F
	property real feelsLike: 0         // °F
	property real windSpeed: 0         // mph
	property int windDirection: 0      // degrees
	property int weatherCode: 0        // WMO code
	property real humidity: 0          // %
	property bool isDay: true

	// Formatted strings for display
	property string tempFormatted: "--°F"
	property string feelsLikeFormatted: "Feels --°F"
	property string windFormatted: "-- mph"
	property string conditionText: "Loading..."
	property string iconName: "not-available"

	// Hourly forecast (next 24h from current time)
	property var hourlyForecast: []   // [{hour, temp, precip, code, isDay}, ...]

	// Daily forecast (10-day)
	property var dailyForecast: []    // [{dayName, high, low, precip, code}, ...]

	// Location (configurable, hardcoded for now)
	property real latitude: 41.88
	property real longitude: -87.63

	// WMO code → condition text
	function _conditionText(code) {
		switch (true) {
			case code === 0:  return "Clear"
			case code <= 2:   return "Partly Cloudy"
			case code === 3:  return "Overcast"
			case code <= 48:  return "Fog"
			case code <= 55:  return "Drizzle"
			case code <= 57:  return "Freezing Drizzle"
			case code <= 65:  return "Rain"
			case code <= 67:  return "Freezing Rain"
			case code <= 77:  return "Snow"
			case code <= 82:  return "Rain Showers"
			case code <= 86:  return "Snow Showers"
			case code === 95: return "Thunderstorm"
			case code <= 99:  return "Thunderstorm + Hail"
			default:          return "Unknown"
		}
	}

	// WMO code + day/night → icon slug
	function _iconName(code, isDay) {
		var suffix = isDay ? "day" : "night"
		switch (true) {
			case code === 0:  return "clear-" + suffix
			case code === 1:  return "mostly-clear-" + suffix
			case code === 2:  return "partly-cloudy-" + suffix
			case code === 3:  return "overcast-" + suffix
			case code <= 48:  return "fog-" + suffix
			case code <= 55:  return "overcast-" + suffix + "-drizzle"
			case code <= 57:  return "overcast-" + suffix + "-sleet"
			case code <= 65:  return "overcast-" + suffix + "-rain"
			case code <= 67:  return "overcast-" + suffix + "-sleet"
			case code <= 77:  return "overcast-" + suffix + "-snow"
			case code <= 82:  return "overcast-" + suffix + "-rain"
			case code <= 86:  return "overcast-" + suffix + "-snow"
			case code === 95: return "thunderstorms-" + suffix
			case code <= 99:  return "thunderstorms-" + suffix + "-hail"
			default:          return "not-available"
		}
	}

	// Wind direction → compass label
	function _windDir(deg) {
		var dirs = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
					"S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
		return dirs[Math.round(deg / 22.5) % 16]
	}

	Timer {
		interval: 900000  // 15 min
		running: true
		repeat: true
		onTriggered: forecastProc.running = true
	}

	// Initial fetch on startup
	Component.onCompleted: forecastProc.running = true

	Process {
		id: forecastProc
		command: ["sh", "-c", "curl -s 'https://api.open-meteo.com/v1/forecast?latitude=" + weatherData.latitude + "&longitude=" + weatherData.longitude + "&current=temperature_2m,apparent_temperature,wind_speed_10m,wind_direction_10m,weather_code,relative_humidity_2m,is_day&hourly=temperature_2m,precipitation_probability,weather_code,is_day,wind_speed_10m,wind_direction_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,wind_speed_10m_max,wind_direction_10m_dominant&forecast_days=10&temperature_unit=fahrenheit&wind_speed_unit=mph&timezone=auto'"]
		stdout: StdioCollector {
			onStreamFinished: {
				try {
					var json = JSON.parse(this.text)
					var c = json.current
					if (!c) return

					weatherData.temperature = c.temperature_2m || 0
					weatherData.feelsLike = c.apparent_temperature || 0
					weatherData.windSpeed = c.wind_speed_10m || 0
					weatherData.windDirection = c.wind_direction_10m || 0
					weatherData.weatherCode = c.weather_code || 0
					weatherData.humidity = c.relative_humidity_2m || 0
					weatherData.isDay = c.is_day === 1

					weatherData.tempFormatted = Math.round(weatherData.temperature) + "°F"
					weatherData.feelsLikeFormatted = "Feels " + Math.round(weatherData.feelsLike) + "°F"
					weatherData.windFormatted = Math.round(weatherData.windSpeed) + " mph " + weatherData._windDir(weatherData.windDirection)
					weatherData.conditionText = weatherData._conditionText(weatherData.weatherCode)
					weatherData.iconName = weatherData._iconName(weatherData.weatherCode, weatherData.isDay)

					// Parse hourly — find current hour index, slice next 24
					var hourly = json.hourly
					if (hourly && hourly.time) {
						var now = new Date()
						var startIdx = 0
						for (var i = 0; i < hourly.time.length; i++) {
							if (new Date(hourly.time[i]) > now) { startIdx = i; break }
						}
						var forecast = []
						var count = Math.min(24, hourly.time.length - startIdx)
						for (var j = 0; j < count; j++) {
							var idx = startIdx + j
							var t = new Date(hourly.time[idx])
							var hrs = t.getHours()
							var hh = hrs < 10 ? "0" + hrs : "" + hrs
							var mm = t.getMinutes() < 10 ? "0" + t.getMinutes() : "" + t.getMinutes()
						forecast.push({
							hour: hh + ":" + mm,
							temp: Math.round(hourly.temperature_2m[idx] || 0),
							precip: Math.round(hourly.precipitation_probability[idx] || 0),
							code: hourly.weather_code[idx] || 0,
							isDay: hourly.is_day[idx] === 1,
							icon: weatherData._iconName(hourly.weather_code[idx] || 0, hourly.is_day[idx] === 1),
							windSpeed: Math.round(hourly.wind_speed_10m[idx] || 0),
							windDir: hourly.wind_direction_10m[idx] || 0,
							windFormatted: Math.round(hourly.wind_speed_10m[idx] || 0) + " mph " + weatherData._windDir(hourly.wind_direction_10m[idx] || 0)
						})
						}
						weatherData.hourlyForecast = forecast
					}

					// Parse daily — 10-day forecast
					var daily = json.daily
					if (daily && daily.time) {
						var dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
						var days = []
						for (var d = 0; d < daily.time.length; d++) {
							var dt = new Date(daily.time[d] + "T12:00:00")
					days.push({
						dayName: dayNames[dt.getDay()],
						high: Math.round(daily.temperature_2m_max[d] || 0),
						low: Math.round(daily.temperature_2m_min[d] || 0),
						precip: Math.round(daily.precipitation_probability_max[d] || 0),
						code: daily.weather_code[d] || 0,
						icon: weatherData._iconName(daily.weather_code[d] || 0, true),
						windSpeed: Math.round(daily.wind_speed_10m_max[d] || 0),
						windDir: daily.wind_direction_10m_dominant[d] || 0,
						windFormatted: Math.round(daily.wind_speed_10m_max[d] || 0) + " mph " + weatherData._windDir(daily.wind_direction_10m_dominant[d] || 0)
					})
						}
						weatherData.dailyForecast = days
					}
				} catch (e) {
					weatherData.conditionText = "Fetch Error"
				}
			}
		}
	}
}
