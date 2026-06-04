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

	Process {
		id: forecastProc
		command: ["curl", "-s",
			"https://api.open-meteo.com/v1/forecast?latitude=" + weatherData.latitude + "&longitude=" + weatherData.longitude +
			"&current=temperature_2m,apparent_temperature,wind_speed_10m,wind_direction_10m,weather_code,relative_humidity_2m,is_day" +
			"&temperature_unit=fahrenheit&wind_speed_unit=mph&timezone=auto"
		]
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
				} catch (e) {
					weatherData.conditionText = "Fetch Error"
				}
			}
		}
	}
}
