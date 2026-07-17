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
	// Marion, Iowa
	property real latitude: 42.057752
	property real longitude: -91.574525

	// ── NWS Active Alerts ──
	property var activeAlerts: []             // array of parsed alert objects
	property int alertCount: 0
	property string maxSeverity: "None"       // "None" | "Minor" | "Moderate" | "Severe" | "Extreme"
	property color alertColor: "#cfd3db"      // severity ramp color
	property string alertIcon: "weather-alert" // Meteocons slug for highest-severity event
	property string alertTickerText: "Weather Patterns Nominal"
	property string alertExpiresText: ""      // human-readable "expires HH:MM AM/PM"

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

	// ── NWS alert helpers ──

	// Severity enum → numeric rank (higher = more severe)
	function _severityRank(sev) {
		switch (sev) {
			case "Extreme":  return 4
			case "Severe":   return 3
			case "Moderate": return 2
			case "Minor":    return 1
			default:         return 0  // "Unknown" or "None"
		}
	}

	// Severity → color (ramp locked by user)
	function _severityColor(sev) {
		switch (sev) {
			case "Extreme":  return "#c31700"
			case "Severe":   return "#ff211b"
			case "Moderate": return "#ffc42d"
			case "Minor":    return "#74e91c"
			default:         return "#cfd3db"  // Unknown / no alert
		}
	}

	// NWS event string → Meteocons icon slug
	function _alertIcon(event) {
		var e = (event || "").toLowerCase()
		if (e.includes("tornado"))                            return "tornado-alert"
		if (e.includes("thunderstorm"))                       return e.includes("warning") ? "thunderstorms-extreme" : "thunderstorms"
		if (e.includes("flash flood") || e.includes("flood")) return "water-alert"
		if (e.includes("hurricane") || e.includes("typhoon")) return "hurricane-alert"
		if (e.includes("tropical storm"))                     return "cyclone-alert"
		if (e.includes("blizzard"))                           return "wind-snow"
		if (e.includes("winter storm"))                      return "extreme-snow"
		if (e.includes("ice storm"))                          return "extreme-hail"
		if (e.includes("extreme heat") || e.includes("excessive heat")) return "thermometer-alert"
		if (e.includes("heat"))                              return e.includes("warning") ? "thermometer-alert" : "thermometer-warmer"
		if (e.includes("extreme cold") || e.includes("wind chill")) return "thermometer-colder"
		if (e.includes("freeze") || e.includes("frost"))     return "snowflake"
		if (e.includes("high wind"))                         return "wind-alert"
		if (e.includes("wind advisory"))                     return "wind"
		if (e.includes("red flag") || e.includes("fire weather") || e.includes("fire warning")) return "fire-alert"
		if (e.includes("dense fog") || e.includes("fog"))    return "fog"
		if (e.includes("dense smoke") || e.includes("smoke")) return "smoke"
		if (e.includes("air quality"))                       return "haze"
		if (e.includes("dust storm") || e.includes("blowing dust")) return "dust"
		if (e.includes("avalanche"))                         return "avalanche-danger-alert"
		if (e.includes("tsunami"))                           return "water-alert"
		if (e.includes("storm surge"))                       return "water-alert"
		if (e.includes("snow squall"))                        return "wind-snow"
		if (e.includes("rip current") || e.includes("beach")) return "water"
		return "weather-alert"  // generic fallback
	}

	// Strip the "issued ... by NWS ..." boilerplate, keep action + time
	function _shortHeadline(headline) {
		if (!headline) return ""
		// "Extreme Heat Warning issued July 1 at 9:56AM CDT until July 3 at 12:00AM CDT by NWS Chicago IL"
		// → "Extreme Heat Warning until July 3 at 12:00AM CDT"
		var m = headline.match(/^(.+?) issued .+? until (.+?) by NWS .+$/i)
		if (m) return m[1] + " until " + m[2]
		// Fallback: trim at "by NWS"
		var idx = headline.indexOf(" by NWS")
		if (idx > 0) return headline.substring(0, idx)
		return headline
	}

	// Format ISO 8601 expiry → "expires HH:MM AM/PM"
	function _formatExpiry(iso) {
		if (!iso) return ""
		var d = new Date(iso)
		if (isNaN(d.getTime())) return ""
		var h = d.getHours()
		var ampm = h >= 12 ? "PM" : "AM"
		var h12 = h % 12 || 12
		var m = d.getMinutes()
		var mm = m < 10 ? "0" + m : "" + m
		return "expires " + h12 + ":" + mm + " " + ampm
	}

	// Process alerts array → set all alert* properties on weatherData
	function _processAlerts(alerts) {
		// Defensive filter: only currently-active alerts
		var now = new Date()
		var live = []
		for (var i = 0; i < alerts.length; i++) {
			var a = alerts[i]
			if (a.expires) {
				var exp = new Date(a.expires)
				if (!isNaN(exp.getTime()) && exp <= now) continue
			}
			live.push(a)
		}

		// Sort by severity rank desc (most severe first)
		live.sort(function (x, y) {
			return weatherData._severityRank(y.severity) - weatherData._severityRank(x.severity)
		})

		weatherData.activeAlerts = live
		weatherData.alertCount = live.length

		if (live.length === 0) {
			weatherData.maxSeverity = "None"
			weatherData.alertColor = weatherData._severityColor("None")
			weatherData.alertIcon = "weather-alert"
			weatherData.alertTickerText = "Weather Patterns Nominal"
			weatherData.alertExpiresText = ""
			return
		}

		// Primary alert = highest severity (first after sort)
		var primary = live[0]
		weatherData.maxSeverity = primary.severity
		weatherData.alertColor = weatherData._severityColor(primary.severity)
		weatherData.alertIcon = weatherData._alertIcon(primary.event)

		// Build ticker text: join each event + short headline with " · "
		var parts = []
		for (var k = 0; k < live.length; k++) {
			parts.push(live[k].event + " — " + weatherData._shortHeadline(live[k].headline))
		}
		weatherData.alertTickerText = parts.join("  ·  ")
		weatherData.alertExpiresText = weatherData._formatExpiry(primary.expires)
	}

	Timer {
		interval: 900000  // 15 min
		running: true
		repeat: true
		onTriggered: forecastProc.running = true
	}

	// 5-minute alert poll (separate cadence from forecast)
	Timer {
		interval: 300000  // 5 min
		running: true
		repeat: true
		onTriggered: alertsProc.running = true
	}

	// Initial fetch on startup
	Component.onCompleted: {
		forecastProc.running = true
		alertsProc.running = true
	}

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

	// ── NWS Active Alerts Process ──
	// Polls api.weather.gov every 5 min (driven by separate Timer).
	// Requires User-Agent header (NWS enforces it). Silent fail: keeps last known state.
	Process {
		id: alertsProc
		command: ["sh", "-c", "curl -s -H 'User-Agent: (quickshell-dashboard, tmoneyrolling@gmail.com)' -H 'Accept: application/geo+json' 'https://api.weather.gov/alerts/active?point=" + weatherData.latitude + "," + weatherData.longitude + "'"]
		stdout: StdioCollector {
			onStreamFinished: {
				try {
					var json = JSON.parse(this.text)
					var features = json.features || []
					var alerts = []
					for (var i = 0; i < features.length; i++) {
						var p = features[i].properties
						if (!p) continue
						if (p.status && p.status !== "Actual") continue
						if (p.messageType === "Cancel") continue
						alerts.push({
							event:      p.event || "Unknown Event",
							headline:   p.headline || "",
							severity:   p.severity || "Unknown",
							urgency:    p.urgency || "Unknown",
							certainty:  p.certainty || "Unknown",
							expires:    p.expires || "",
							ends:       p.ends || "",
							areaDesc:   p.areaDesc || ""
						})
					}
					weatherData._processAlerts(alerts)
				} catch (e) {
					// Silent fail — keep last known alerts, don't nuke UI on transient error
				}
			}
		}
	}
}
