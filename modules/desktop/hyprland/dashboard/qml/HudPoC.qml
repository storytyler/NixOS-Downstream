// HudPoC.qml — Dashboard layout: stacked gauge+graph top-left, status top-right
// DialGauge: uniform gray (#cfd3db / #8f8f8f / #6b6b6b)
// GlowSparkline: matching palette, no panel border when paired with gauge
// Status panel: top-right, dynamic font sizing
import QtQuick

Item {
	id: poc

	// ── Uniform gray palette ──
	property color light: "#cfd3db"
	property color mid: "#8f8f8f"
	property color dark: "#6b6b6b"
	property color accent: "#f7768e"

	// ── Simulated values ──
	property real cpuValue: 0.58
	property real memValue: 0.42
	property real gpuValue: 0.73

	// ── Data simulation timer (1s random walk) ──
	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: {
			poc.cpuValue = Math.max(0.1, Math.min(0.95,
				poc.cpuValue + (Math.random() - 0.48) * 0.08))
			poc.memValue = Math.max(0.15, Math.min(0.85,
				poc.memValue + (Math.random() - 0.48) * 0.05))
			poc.gpuValue = Math.max(0.2, Math.min(0.95,
				poc.gpuValue + (Math.random() - 0.48) * 0.06))
		}
	}

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
	// LEFT COLUMN: Stacked gauge + sparkline groups
	// CPU gauge → CPU graph → MEM gauge → MEM graph → GPU gauge → GPU graph
	// ═══════════════════════════════════════════════
	Column {
		id: leftColumn
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.margins: 30
		width: parent.width * 0.32
		height: parent.height * 0.48

		spacing: 6

		// ── CPU ──
		Column {
			width: parent.width
			height: (leftColumn.height - leftColumn.spacing * 5) / 3
			spacing: 2

			DialGauge {
				width: parent.width
				height: parent.height * 0.72
				label: "CPU"
				value: poc.cpuValue
				lightColor: poc.light
				midColor: poc.mid
				darkColor: poc.dark
			}

			GlowSparkline {
				width: parent.width
				height: parent.height * 0.26
				label: "CPU"
				value: poc.cpuValue
				lineColor: poc.mid
				textColor: poc.light
				dimColor: poc.dark
				showPanel: false
			}
		}

		// ── MEMORY ──
		Column {
			width: parent.width
			height: (leftColumn.height - leftColumn.spacing * 5) / 3
			spacing: 2

			DialGauge {
				width: parent.width
				height: parent.height * 0.72
				label: "MEMORY"
				value: poc.memValue
				lightColor: poc.light
				midColor: poc.mid
				darkColor: poc.dark
			}

			GlowSparkline {
				width: parent.width
				height: parent.height * 0.26
				label: "MEM"
				value: poc.memValue
				lineColor: poc.mid
				textColor: poc.light
				dimColor: poc.dark
				showPanel: false
			}
		}

		// ── GPU ──
		Column {
			width: parent.width
			height: (leftColumn.height - leftColumn.spacing * 5) / 3
			spacing: 2

			DialGauge {
				width: parent.width
				height: parent.height * 0.72
				label: "GPU"
				value: poc.gpuValue
				lightColor: poc.light
				midColor: poc.mid
				darkColor: poc.dark
			}

			GlowSparkline {
				width: parent.width
				height: parent.height * 0.26
				label: "GPU"
				value: poc.gpuValue
				lineColor: poc.mid
				textColor: poc.light
				dimColor: poc.dark
				showPanel: false
			}
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
		width: parent.width * 0.32
		height: parent.height * 0.48

		// Panel border
		Canvas {
			anchors.fill: parent
			onPaint: {
				var ctx = getContext("2d")
				ctx.reset()
				poc.rr(ctx, 3, 3, width - 6, height - 6, 12)
				ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
				ctx.fill()
				ctx.shadowBlur = 20
				ctx.shadowColor = "#f7768e"
				ctx.strokeStyle = "#f7768e"
				ctx.lineWidth = 1.5
				poc.rr(ctx, 3, 3, width - 6, height - 6, 12)
				ctx.stroke()
				ctx.shadowBlur = 0
			}
		}

		// SYSTEM ONLINE (dynamic font)
		Text {
			id: statusText
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: parent.height * 0.05
			text: "SYSTEM ONLINE"
			color: "#f7768e"
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

			onPaint: {
				var ctx = getContext("2d")
				ctx.reset()
				var fontSize = Math.max(9, Math.round(height * 0.055))
				ctx.shadowBlur = 6
				ctx.shadowColor = "#f7768e"
				ctx.fillStyle = Qt.rgba(0.97, 0.46, 0.56, 0.7)
				ctx.font = fontSize + "px monospace"
				ctx.textAlign = "left"
				ctx.textBaseline = "top"

				var lines = [
					"Speed: 130 MPH",
					"Alt: -30M",
					"Ext Temp: 57\u2109",
					"Int Temp: 86\u2109",
					"Status: Good",
					"Uptime: 4d 7h",
					"Load: 2.41",
					"CPU: " + Math.round(poc.cpuValue * 100) + "%",
					"MEM: " + Math.round(poc.memValue * 100) + "%",
					"GPU: " + Math.round(poc.gpuValue * 100) + "%",
					"Net: 142 Mb/s",
					"Disk: 340G/2T",
					"Procs: 387",
					"Threads: 1249"
				]
				var lineH = fontSize * 1.7
				for (var i = 0; i < lines.length; i++) {
					ctx.fillText(lines[i], 4, 4 + i * lineH)
				}
				ctx.shadowBlur = 0
			}

			// Repaint when simulated values change
			property real _t1: poc.cpuValue
			property real _t2: poc.memValue
			property real _t3: poc.gpuValue
			on_T1Changed: requestPaint()
			on_T2Changed: requestPaint()
			on_T3Changed: requestPaint()
		}
	}
}
