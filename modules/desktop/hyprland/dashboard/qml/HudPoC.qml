// HudPoC.qml — Proof-of-concept for vuild.com-style HUD effects
// Tests: Canvas shadowBlur glow, spinning dial arcs, transparency,
//        text glow, bar gauges, flicker animation
// Reference: https://vuild.com/suit/ (HTML/CSS Iron Man HUD)
import QtQuick

Item {
	id: poc

	// Tokyo Night colors (from shell.qml PersistentProperties)
	property color primary: "#7aa2f7"
	property color surface: "#1a1b26"
	property color textMain: "#c0caf5"
	property color textDim: "#565f89"
	property color accent: "#f7768e"
	property color green: "#9ece6a"
	property color orange: "#e0af68"

	// Simulated values
	property real cpuValue: 0.58
	property real memValue: 0.42
	property real gpuValue: 0.73

	// Helper: draw a rounded rectangle path (CSS border-radius equivalent)
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

	Row {
		anchors.centerIn: parent
		spacing: 30

		// =====================================================
		// TEST 1: Hero dial gauge (vuild spinning dial pattern)
		// Two concentric arc rings spinning in opposite directions
		// with a value arc and glowing text readout in the center.
		// =====================================================
		Item {
			width: 240
			height: 240

			// -- Panel background with glowing border --
			Canvas {
				id: heroPanel
				anchors.fill: parent

				onPaint: {
					var ctx = getContext("2d")
					ctx.reset()
					var m = 4
					var w = width - m * 2
					var h = height - m * 2
					var r = 12

					// Dark transparent fill (vuild: background: rgba(0,0,0,.2))
					poc.rr(ctx, m, m, w, h, r)
					ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
					ctx.fill()

					// Glowing border (vuild: box-shadow: 0 0 10px #07C4FF + border: 2px solid #07C4FF)
					ctx.shadowBlur = 25
					ctx.shadowColor = "#7aa2f7"
					ctx.strokeStyle = "#7aa2f7"
					ctx.lineWidth = 1.5
					poc.rr(ctx, m, m, w, h, r)
					ctx.stroke()
					ctx.shadowBlur = 0
				}
			}

			// -- Outer spinning arc ring (clockwise, 4s) --
			Canvas {
				id: outerDial
				anchors.centerIn: parent
				width: 200
				height: 200

				property real dialAngle: 0

				NumberAnimation on dialAngle {
					from: 0; to: 360; duration: 4000; loops: Animation.Infinite
				}

				onDialAngleChanged: requestPaint()

				onPaint: {
					var ctx = getContext("2d")
					ctx.reset()
					var cx = width / 2, cy = height / 2
					var r = Math.max(1, Math.min(cx, cy) - 12)
					var base = dialAngle * Math.PI / 180

					ctx.shadowBlur = 12
					ctx.shadowColor = "#7aa2f7"
					ctx.strokeStyle = "#7aa2f7"
					ctx.lineWidth = 2.5
					ctx.lineCap = "round"

					// 8 evenly-spaced arc segments
					for (var i = 0; i < 8; i++) {
						var a = base + i * Math.PI / 4
						ctx.beginPath()
						ctx.arc(cx, cy, r, a, a + 0.45)
						ctx.stroke()
					}
					ctx.shadowBlur = 0
				}
			}

			// -- Inner spinning arc ring (counter-clockwise, 6s) --
			Canvas {
				id: innerDial
				anchors.centerIn: parent
				width: 150
				height: 150

				property real dialAngle: 0

				NumberAnimation on dialAngle {
					from: 360; to: 0; duration: 6000; loops: Animation.Infinite
				}

				onDialAngleChanged: requestPaint()

				onPaint: {
					var ctx = getContext("2d")
					ctx.reset()
					var cx = width / 2, cy = height / 2
					var r = Math.max(1, Math.min(cx, cy) - 10)
					var base = dialAngle * Math.PI / 180

					ctx.shadowBlur = 8
					ctx.shadowColor = Qt.rgba(0.48, 0.64, 0.97, 0.6)
					ctx.strokeStyle = Qt.rgba(0.48, 0.64, 0.97, 0.5)
					ctx.lineWidth = 1.5
					ctx.lineCap = "round"

					// 6 evenly-spaced arc segments
					for (var i = 0; i < 6; i++) {
						var a = base + i * Math.PI / 3
						ctx.beginPath()
						ctx.arc(cx, cy, r, a, a + 0.55)
						ctx.stroke()
					}
					ctx.shadowBlur = 0
				}
			}

			// -- Value arc (actual data, like RadialGauge but with glow) --
			Canvas {
				id: valueArc
				anchors.centerIn: parent
				width: 110
				height: 110

				property real value: poc.gpuValue
				onValueChanged: requestPaint()

				onPaint: {
					var ctx = getContext("2d")
					ctx.reset()
					var cx = width / 2, cy = height / 2
					var r = Math.max(1, Math.min(cx, cy) - 8)

					// Track
					ctx.beginPath()
					ctx.arc(cx, cy, r, 0, 2 * Math.PI)
					ctx.strokeStyle = Qt.rgba(0.48, 0.64, 0.97, 0.12)
					ctx.lineWidth = 5
					ctx.stroke()

					// Value arc with glow
					if (value > 0.001) {
						var s = -Math.PI / 2
						var e = s + 2 * Math.PI * value
						ctx.shadowBlur = 15
						ctx.shadowColor = "#7aa2f7"
						ctx.beginPath()
						ctx.arc(cx, cy, r, s, e)
						ctx.strokeStyle = "#7aa2f7"
						ctx.lineWidth = 5
						ctx.lineCap = "round"
						ctx.stroke()
						ctx.shadowBlur = 0
					}
				}
			}

			// -- Center text with glow (Canvas shadowBlur on text) --
			Canvas {
				id: heroText
				anchors.centerIn: parent
				width: 90
				height: 60

				property real _trigger: poc.gpuValue
				on_TriggerChanged: requestPaint()

				onPaint: {
					var ctx = getContext("2d")
					ctx.reset()
					ctx.shadowBlur = 10
					ctx.shadowColor = "#7aa2f7"
					ctx.fillStyle = "#c0caf5"
					ctx.font = "bold 26px monospace"
					ctx.textAlign = "center"
					ctx.textBaseline = "middle"
					ctx.fillText(Math.round(poc.gpuValue * 100) + "%", width / 2, height / 2)
					ctx.shadowBlur = 0
				}
			}

			// Label
			Text {
				anchors.top: parent.top
				anchors.topMargin: 16
				anchors.horizontalCenter: parent.horizontalCenter
				text: "GPU"
				color: poc.textDim
				font.pointSize: 10
				font.family: "monospace"
				font.bold: true
			}
		}

		// =====================================================
		// TEST 2: Stat bars with glowing panel borders
		// (vuild .meta class pattern: dark transparent bg,
		//  colored border, shadow glow, bar gauge inside)
		// =====================================================
		Column {
			spacing: 14
			anchors.verticalCenter: parent.verticalCenter

			// --- CPU bar ---
			Item {
				width: 280
				height: 64

				Canvas {
					anchors.fill: parent
					onPaint: {
						var ctx = getContext("2d")
						ctx.reset()
						poc.rr(ctx, 2, 2, width - 4, height - 4, 8)
						ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
						ctx.fill()
						ctx.shadowBlur = 15
						ctx.shadowColor = "#7aa2f7"
						ctx.strokeStyle = "#7aa2f7"
						ctx.lineWidth = 1.5
						poc.rr(ctx, 2, 2, width - 4, height - 4, 8)
						ctx.stroke()
						ctx.shadowBlur = 0
					}
				}

				Canvas {
					anchors.fill: parent
					anchors.margins: 14
					anchors.topMargin: 24
					anchors.bottomMargin: 16

					property real value: poc.cpuValue
					onValueChanged: requestPaint()

					onPaint: {
						var ctx = getContext("2d")
						ctx.reset()

						// Track
						poc.rr(ctx, 0, 0, width, height, 3)
						ctx.fillStyle = Qt.rgba(0.2, 0.2, 0.3, 0.3)
						ctx.fill()

						// Fill with glow
						var fillW = width * value
						if (fillW > 4) {
							ctx.shadowBlur = 8
							ctx.shadowColor = "#7aa2f7"
							poc.rr(ctx, 0, 0, fillW, height, 3)
							ctx.fillStyle = "#7aa2f7"
							ctx.fill()
							ctx.shadowBlur = 0
						}
					}
				}

				Text {
					anchors.left: parent.left
					anchors.leftMargin: 14
					anchors.top: parent.top
					anchors.topMargin: 5
					text: "CPU"
					color: poc.textDim
					font.pointSize: 9
					font.family: "monospace"
					font.bold: true
				}

				Text {
					anchors.right: parent.right
					anchors.rightMargin: 14
					anchors.top: parent.top
					anchors.topMargin: 5
					text: Math.round(poc.cpuValue * 100) + "%"
					color: "#7aa2f7"
					font.pointSize: 9
					font.family: "monospace"
					font.bold: true
				}
			}

			// --- MEM bar ---
			Item {
				width: 280
				height: 64

				Canvas {
					anchors.fill: parent
					onPaint: {
						var ctx = getContext("2d")
						ctx.reset()
						poc.rr(ctx, 2, 2, width - 4, height - 4, 8)
						ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
						ctx.fill()
						ctx.shadowBlur = 15
						ctx.shadowColor = "#9ece6a"
						ctx.strokeStyle = "#9ece6a"
						ctx.lineWidth = 1.5
						poc.rr(ctx, 2, 2, width - 4, height - 4, 8)
						ctx.stroke()
						ctx.shadowBlur = 0
					}
				}

				Canvas {
					anchors.fill: parent
					anchors.margins: 14
					anchors.topMargin: 24
					anchors.bottomMargin: 16

					property real value: poc.memValue
					onValueChanged: requestPaint()

					onPaint: {
						var ctx = getContext("2d")
						ctx.reset()
						poc.rr(ctx, 0, 0, width, height, 3)
						ctx.fillStyle = Qt.rgba(0.2, 0.2, 0.3, 0.3)
						ctx.fill()
						var fillW = width * value
						if (fillW > 4) {
							ctx.shadowBlur = 8
							ctx.shadowColor = "#9ece6a"
							poc.rr(ctx, 0, 0, fillW, height, 3)
							ctx.fillStyle = "#9ece6a"
							ctx.fill()
							ctx.shadowBlur = 0
						}
					}
				}

				Text {
					anchors.left: parent.left
					anchors.leftMargin: 14
					anchors.top: parent.top
					anchors.topMargin: 5
					text: "MEM"
					color: poc.textDim
					font.pointSize: 9
					font.family: "monospace"
					font.bold: true
				}

				Text {
					anchors.right: parent.right
					anchors.rightMargin: 14
					anchors.top: parent.top
					anchors.topMargin: 5
					text: Math.round(poc.memValue * 100) + "%"
					color: "#9ece6a"
					font.pointSize: 9
					font.family: "monospace"
					font.bold: true
				}
			}

			// --- TEMP bar ---
			Item {
				width: 280
				height: 64

				Canvas {
					anchors.fill: parent
					onPaint: {
						var ctx = getContext("2d")
						ctx.reset()
						poc.rr(ctx, 2, 2, width - 4, height - 4, 8)
						ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
						ctx.fill()
						ctx.shadowBlur = 15
						ctx.shadowColor = "#e0af68"
						ctx.strokeStyle = "#e0af68"
						ctx.lineWidth = 1.5
						poc.rr(ctx, 2, 2, width - 4, height - 4, 8)
						ctx.stroke()
						ctx.shadowBlur = 0
					}
				}

				Canvas {
					anchors.fill: parent
					anchors.margins: 14
					anchors.topMargin: 24
					anchors.bottomMargin: 16

					property real value: 0.65
					onValueChanged: requestPaint()

					onPaint: {
						var ctx = getContext("2d")
						ctx.reset()
						poc.rr(ctx, 0, 0, width, height, 3)
						ctx.fillStyle = Qt.rgba(0.2, 0.2, 0.3, 0.3)
						ctx.fill()
						var fillW = width * value
						if (fillW > 4) {
							ctx.shadowBlur = 8
							ctx.shadowColor = "#e0af68"
							poc.rr(ctx, 0, 0, fillW, height, 3)
							ctx.fillStyle = "#e0af68"
							ctx.fill()
							ctx.shadowBlur = 0
						}
					}
				}

				Text {
					anchors.left: parent.left
					anchors.leftMargin: 14
					anchors.top: parent.top
					anchors.topMargin: 5
					text: "TEMP"
					color: poc.textDim
					font.pointSize: 9
					font.family: "monospace"
					font.bold: true
				}

				Text {
					anchors.right: parent.right
					anchors.rightMargin: 14
					anchors.top: parent.top
					anchors.topMargin: 5
					text: "65%"
					color: "#e0af68"
					font.pointSize: 9
					font.family: "monospace"
					font.bold: true
				}
			}
		}

		// =====================================================
		// TEST 3: Flickering status panel + data readout
		// Tests: SequentialAnimation opacity (vuild flicker),
		//        Canvas text glow on multi-line readout
		// =====================================================
		Item {
			width: 180
			height: 240

			Canvas {
				anchors.fill: parent
				onPaint: {
					var ctx = getContext("2d")
					ctx.reset()
					poc.rr(ctx, 2, 2, width - 4, height - 4, 12)
					ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
					ctx.fill()
					ctx.shadowBlur = 20
					ctx.shadowColor = "#f7768e"
					ctx.strokeStyle = "#f7768e"
					ctx.lineWidth = 1.5
					poc.rr(ctx, 2, 2, width - 4, height - 4, 12)
					ctx.stroke()
					ctx.shadowBlur = 0
				}
			}

			// Flickering "SYSTEM ONLINE" text (vuild @keyframes flicker)
			Text {
				id: statusFlicker
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 20
				text: "SYSTEM ONLINE"
				color: "#f7768e"
				font.pointSize: 10
				font.family: "monospace"
				font.bold: true
				horizontalAlignment: Text.AlignHCenter

				SequentialAnimation on opacity {
					loops: Animation.Infinite
					NumberAnimation { to: 0.2; duration: 400 }
					NumberAnimation { to: 1.0; duration: 400 }
				}
			}

			// Data readout with glow (vuild summary-box pattern)
			Canvas {
				id: dataReadout
				anchors.top: statusFlicker.bottom
				anchors.topMargin: 16
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.leftMargin: 14
				anchors.rightMargin: 14
				height: 160

				onPaint: {
					var ctx = getContext("2d")
					ctx.reset()
					ctx.shadowBlur = 6
					ctx.shadowColor = "#f7768e"
					ctx.fillStyle = Qt.rgba(0.97, 0.46, 0.56, 0.7)
					ctx.font = "9px monospace"
					ctx.textAlign = "left"
					ctx.textBaseline = "top"

					var lines = [
						"Speed: 130 MPH",
						"Alt: -30M",
						"Ext Temp: 57\u2109",
						"Int Temp: 86\u2109",
						"Status: Good",
						"Uptime: 4d 7h",
						"Load: 2.41"
					]
					for (var i = 0; i < lines.length; i++) {
						ctx.fillText(lines[i], 4, 4 + i * 20)
					}
					ctx.shadowBlur = 0
				}
			}
		}
	}
}
