// HudPoC.qml — Dashboard layout: three gauges top-left, status panel top-right
// DialGauge: neutral ramp (N1→N5), staggered collecting arcs, desynced patterns
// Data: real system metrics via services/ (CpuData, MemData, GpuData, NetData, etc.)
// Status panel: live metrics grouped — system, disk, net+signal
import QtQuick
import "services"

Item {
	id: poc
	opacity: 0.7

	// ── Neutral ramp palette ──
	property color n1: "#1f1f1f"
	property color n2: "#323232"
	property color n3: "#6b6b6b"
	property color n4: "#8f8f8f"
	property color n5: "#cfd3db"

	// ── Data services (real system metrics) ──
	CpuData { id: cpuData }
	MemData { id: memData }
	GpuData { id: gpuData }
	NetData { id: netData }
	DiskData { id: diskData }
	SysInfo { id: sysInfo }
	SignalData { id: signalData }
	WeatherData { id: weatherData }

	// ── Helper: rounded rect path ──
	function rr(ctx, x, y, w, h, r) {
		ctx.beginPath()
		ctx.moveTo(x + r, y)
		ctx.lineTo(x + w - r, y)
		ctx.arcTo(x + w, y, x + w, y + r, r)
		ctx.lineTo(x + w, y + h - r)
		ctx.arcTo(x + w, y + h, x + w - r, y + h, r)
		ctx.lineTo(x + r, y + h)
		ctx.arcTo(x, y + h, x, y + h - r, r)
		ctx.lineTo(x, y + r)
		ctx.arcTo(x, y, x + r, y, r)
		ctx.closePath()
	}

	// ═══════════════════════════════════════════════
	// TOP CENTER: Weather panel
	// Layout: current conditions (top-left) | alert status (top-right)
	//         hourly forecast (middle, full width)
	//         daily forecast (bottom, full width)
	// All text via QML Text (GPU-composited, auto-updating via bindings)
	// ═══════════════════════════════════════════════
	Item {
		id: weatherPanel
		anchors.left: leftColumn.right
		anchors.leftMargin: 20
		anchors.right: rightPanel.left
		anchors.rightMargin: 20
		anchors.top: parent.top
		anchors.topMargin: 30
		height: weatherContent.implicitHeight + 20

		// Panel border (stroke only, no fill, double-stroke glow)
		Canvas {
			anchors.fill: parent
			renderTarget: Canvas.FramebufferObject
			onPaint: {
				var ctx = getContext("2d")
				ctx.reset()
				poc.rr(ctx, 3, 3, width - 6, height - 6, 12)
				ctx.strokeStyle = Qt.rgba(143/255, 143/255, 143/255, 0.12)
				ctx.lineWidth = 10
				ctx.stroke()
				poc.rr(ctx, 3, 3, width - 6, height - 6, 12)
				ctx.strokeStyle = "#8f8f8f"
				ctx.lineWidth = 3
				ctx.stroke()
			}
		}

		Column {
			id: weatherContent
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: 8
			spacing: 6

			// ── Current conditions (left) + Alert status (right) ──
			Item {
				width: parent.width
				height: currentDetails.implicitHeight

				Column {
					id: currentDetails
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					spacing: 3

					Text {
						text: weatherData.conditionText + "  " + weatherData.tempFormatted
						color: "#cfd3db"
						font.pixelSize: 18
						font.family: "monospace"
						font.bold: true
						style: Text.Raised
						styleColor: Qt.rgba(207/255, 211/255, 219/255, 0.3)
					}

					Text {
						text: weatherData.feelsLikeFormatted + "  \u00B7  " + weatherData.windFormatted + "  \u00B7  " + Math.round(weatherData.humidity) + "%"
						color: "#8f8f8f"
						font.pixelSize: 13
						font.family: "monospace"
						style: Text.Raised
						styleColor: Qt.rgba(143/255, 143/255, 143/255, 0.2)
					}
				}

				Text {
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					text: "Weather Patterns Nominal"
					color: "#cfd3db"
					font.pixelSize: 13
					font.family: "monospace"
					style: Text.Raised
					styleColor: Qt.rgba(207/255, 211/255, 219/255, 0.2)
				}
			}

			// ── Hourly forecast (6 hours, room for icons later) ──
			Row {
				width: parent.width
				height: 56
				spacing: 0

				Repeater {
					model: Math.min(weatherData.hourlyForecast.length, 6)

					Column {
						required property int index
						width: parent.width / Math.min(weatherData.hourlyForecast.length, 6)
						height: parent.height
						spacing: 2

						Text {
							anchors.horizontalCenter: parent.horizontalCenter
							text: weatherData.hourlyForecast[index] ? weatherData.hourlyForecast[index].hour : ""
							color: "#6b6b6b"
							font.pixelSize: 14
							font.family: "monospace"
						}

						Text {
							anchors.horizontalCenter: parent.horizontalCenter
							text: weatherData.hourlyForecast[index] ? weatherData.hourlyForecast[index].temp + "\u00B0" : ""
							color: "#cfd3db"
							font.pixelSize: 16
							font.family: "monospace"
							font.bold: true
							style: Text.Raised
							styleColor: Qt.rgba(207/255, 211/255, 219/255, 0.2)
						}

						Text {
							anchors.horizontalCenter: parent.horizontalCenter
							visible: weatherData.hourlyForecast[index] && weatherData.hourlyForecast[index].precip > 0
							text: weatherData.hourlyForecast[index] ? weatherData.hourlyForecast[index].precip + "%" : ""
							color: "#8f8f8f"
							font.pixelSize: 12
							font.family: "monospace"
						}
					}
				}
			}

			// ── Daily forecast (5 days, room for icons later) ──
			Row {
				width: parent.width
				height: 64
				spacing: 0

				Repeater {
					model: Math.min(weatherData.dailyForecast.length, 5)

					Column {
						required property int index
						width: Math.min(weatherData.dailyForecast.length, 5) > 0 ? parent.width / Math.min(weatherData.dailyForecast.length, 5) : 0
						height: parent.height
						spacing: 2

						Text {
							anchors.horizontalCenter: parent.horizontalCenter
							text: weatherData.dailyForecast[index] ? weatherData.dailyForecast[index].dayName : ""
							color: index === 0 ? "#cfd3db" : "#6b6b6b"
							font.pixelSize: 14
							font.family: "monospace"
						}

						Text {
							anchors.horizontalCenter: parent.horizontalCenter
							text: weatherData.dailyForecast[index] ? weatherData.dailyForecast[index].high + "\u00B0" : ""
							color: "#cfd3db"
							font.pixelSize: 15
							font.family: "monospace"
							font.bold: true
							style: Text.Raised
							styleColor: Qt.rgba(207/255, 211/255, 219/255, 0.2)
						}

						Text {
							anchors.horizontalCenter: parent.horizontalCenter
							text: weatherData.dailyForecast[index] ? weatherData.dailyForecast[index].low + "\u00B0" : ""
							color: "#8f8f8f"
							font.pixelSize: 14
							font.family: "monospace"
						}

						Text {
							anchors.horizontalCenter: parent.horizontalCenter
							visible: weatherData.dailyForecast[index] && weatherData.dailyForecast[index].precip > 0
							text: weatherData.dailyForecast[index] ? weatherData.dailyForecast[index].precip + "%" : ""
							color: "#6b6b6b"
							font.pixelSize: 9
							font.family: "monospace"
						}
					}
				}
			}
		}
	}

	// ═══════════════════════════════════════════════
	// LEFT COLUMN: Three gauges (sparklines removed for larger gauge allocation)
	// ═══════════════════════════════════════════════
	Column {
		id: leftColumn
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.leftMargin: 0
		anchors.topMargin: 0
		width: (parent.height * 0.48 - spacing * 2) / 3 + 20
		height: parent.height * 0.48
		spacing: 6

		DialGauge {
			width: parent.width
			height: (leftColumn.height - leftColumn.spacing * 2) / 3
			label: "CPU"
			value: cpuData.usage
			temp: cpuData.temp
			// Desync: outer 6 CW, inner 4 CCW
			arcCount: 6; arcLen: 0.4; baseSpeed: 3; arcDir: 1
			innerCount: 4; innerArcLen: 0.5; innerBaseSpeed: 2; innerDir: -1
		}

		DialGauge {
			width: parent.width
			height: (leftColumn.height - leftColumn.spacing * 2) / 3
			label: "MEMORY"
			value: memData.usage
			// Desync: outer 8 CCW short, inner 3 CW long
			arcCount: 8; arcLen: 0.25; baseSpeed: 2; arcDir: -1
			innerCount: 3; innerArcLen: 0.7; innerBaseSpeed: 3.5; innerDir: 1
		}

		DialGauge {
			width: parent.width
			height: (leftColumn.height - leftColumn.spacing * 2) / 3
			label: "GPU"
			value: gpuData.usage
			temp: gpuData.temp
			// Desync: outer 5 CW long, inner 5 CW (same direction)
			arcCount: 5; arcLen: 0.55; baseSpeed: 4; arcDir: 1
			innerCount: 5; innerArcLen: 0.3; innerBaseSpeed: 1.5; innerDir: 1
		}
	}

	// ═══════════════════════════════════════════════
	// RIGHT COLUMN: Status panel
	// Same allocation as left (~1/3 width, ~1/2 height)
	// Dynamic font sizing relative to panel dimensions
	// ═══════════════════════════════════════════════
	Item {
		id: rightPanel
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.margins: 30
		width: parent.width * 0.22
		height: parent.height * 0.48

		// Panel border (stroke only, no fill, double-stroke glow)
		Canvas {
			anchors.fill: parent
			renderTarget: Canvas.FramebufferObject
			onPaint: {
				var ctx = getContext("2d")
				ctx.reset()
				// Glow pass: wider, dimmer
				poc.rr(ctx, 3, 3, width - 6, height - 6, 12)
				ctx.strokeStyle = Qt.rgba(143/255, 143/255, 143/255, 0.12)   // N4 dim
				ctx.lineWidth = 10
				ctx.stroke()
				// Core pass: sharp 2px
				poc.rr(ctx, 3, 3, width - 6, height - 6, 12)
				ctx.strokeStyle = "#8f8f8f"   // N4
				ctx.lineWidth = 3
				ctx.stroke()
			}
		}

		// SYSTEM ONLINE (dynamic font)
		Text {
			id: statusText
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: parent.height * 0.05
			text: "SYSTEM ONLINE"
			color: "#cfd3db"   // N5
			font.pixelSize: Math.max(12, parent.height * 0.04)
			font.family: "monospace"
			font.bold: true
			horizontalAlignment: Text.AlignHCenter

			SequentialAnimation on opacity {
				loops: Animation.Infinite
				NumberAnimation { to: 0.2; duration: 400 }
				NumberAnimation { to: 1.0; duration: 400 }
			}
		}

		// Data readout (dynamic font, fills remaining space)
		Canvas {
			id: dataReadout
			anchors.top: statusText.bottom
			anchors.topMargin: parent.height * 0.04
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: parent.width * 0.06
			renderTarget: Canvas.FramebufferObject

			onPaint: {
				var ctx = getContext("2d")
				ctx.reset()

				var lines = [
					"CPU: " + Math.round(cpuData.usage * 100) + "% \u00B7 " + Math.round(cpuData.temp) + "\u00B0C",
					"MEM: " + Math.round(memData.usage * 100) + "% \u00B7 " + memData.usedGB.toFixed(1) + "G/" + memData.totalGB.toFixed(1) + "G",
					"GPU: " + Math.round(gpuData.usage * 100) + "% \u00B7 " + Math.round(gpuData.temp) + "\u00B0C",
					"",
					"Load: " + sysInfo.load1.toFixed(2) + "  " + sysInfo.load5.toFixed(2) + "  " + sysInfo.load15.toFixed(2),
					"Uptime: " + sysInfo.uptime,
					"Threads: " + sysInfo.threads,
					"",
					"Disk: " + diskData.usedGB.toFixed(0) + "G/" + diskData.totalGB.toFixed(0) + "G" + (diskData.readFormatted ? " \u00B7 R " + diskData.readFormatted : ""),
					"",
					"Net: \u2193 " + netData.downloadFormatted + "  \u2191 " + netData.uploadFormatted,
					"Signal: " + signalData.strengthFormatted
				]

				// Adaptive font size: ensure all lines fit within canvas height
				var lineSpacing = 1.6
				var maxFontSize = Math.round(height * 0.055)
				var fitFontSize = Math.floor((height - 8) / (lines.length * lineSpacing))
				var fontSize = Math.max(8, Math.min(maxFontSize, fitFontSize))
				var lineH = fontSize * lineSpacing

				ctx.fillStyle = "#8f8f8f"   // N4
				ctx.font = fontSize + "px monospace"
				ctx.textAlign = "left"
				ctx.textBaseline = "top"

				for (var i = 0; i < lines.length; i++) {
					ctx.fillText(lines[i], 4, 4 + i * lineH)
				}
			}

			// Repaint status panel at 2s interval (driven by data service polling)
			Timer {
				interval: 2000
				running: true
				repeat: true
				onTriggered: dataReadout.requestPaint()
			}
		}
	}
}
