// GlowSparkline.qml — Scrolling time series with neon glow
// Self-contained panel: glowing border + sparkline graph + label + value readout
//
// Data flow: set `value` (0.0-1.0) from outside. Component manages its own
// ring buffer internally via push/shift. Each value change triggers requestPaint.
//
// Rendering: Canvas shadowBlur glow on line stroke, gradient fill underneath,
// end-point dot at the newest value. Scrolling left-to-right (newest = right).
//
// References:
//   - end-4 Graph.qml (data model, push/shift)
//   - RuView hud-controller.js (shadowBlur sparkline + gradient fill)
//   - bluewave-labs SparklineGraph.qml (end-point dot, double-stroke glow)
//   - ~/Workspace/tmp/quickshell/hud-visual-reference.md
import QtQuick

Item {
	id: panel

	// ── Public API ──
	property string label: "CPU"
	property real value: 0.5              // 0.0 – 1.0, new data point
	property color lineColor: "#7aa2f7"   // stroke + glow color
	property color textColor: "#c0caf5"
	property color dimColor: "#565f89"
	property int maxPoints: 60            // ring buffer size (~2 min at 2s)
	property bool showPanel: true         // set false to hide border + labels

	// ── Internal ──
	property var _history: []

	onValueChanged: {
		_history.push(value)
		if (_history.length > maxPoints)
			_history.shift()
		graphCanvas.requestPaint()
		valueText.text = Math.round(value * 100) + "%"
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

	// ── Glowing panel border ──
	Canvas {
		anchors.fill: parent
		visible: panel.showPanel
		onPaint: {
			var ctx = getContext("2d")
			ctx.reset()
			var m = 2
			var w = width - m * 2
			var h = height - m * 2
			var r = 8

			// Dark transparent fill
			panel.rr(ctx, m, m, w, h, r)
			ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
			ctx.fill()

			// Glowing border (vuild .meta pattern)
			ctx.shadowBlur = 20
			ctx.shadowColor = panel.lineColor
			ctx.strokeStyle = panel.lineColor
			ctx.lineWidth = 1.5
			panel.rr(ctx, m, m, w, h, r)
			ctx.stroke()
			ctx.shadowBlur = 0
		}
	}

	// ── Label (top-left) ──
	Text {
		visible: panel.showPanel
		anchors.left: parent.left
		anchors.leftMargin: 12
		anchors.top: parent.top
		anchors.topMargin: 6
		text: panel.label
		color: panel.dimColor
		font.pointSize: 9
		font.family: "monospace"
		font.bold: true
	}

	// ── Value readout (top-right) ──
	Text {
		id: valueText
		visible: panel.showPanel
		anchors.right: parent.right
		anchors.rightMargin: 12
		anchors.top: parent.top
		anchors.topMargin: 6
		text: Math.round(panel.value * 100) + "%"
		color: panel.lineColor
		font.pointSize: 9
		font.family: "monospace"
		font.bold: true
	}

	// ── Sparkline graph ──
	Canvas {
		id: graphCanvas
		anchors.fill: parent
		anchors.margins: panel.showPanel ? 12 : 2
		anchors.topMargin: panel.showPanel ? 22 : 2

		onPaint: {
			var ctx = getContext("2d")
			ctx.reset()
			var w = width, h = height

			if (panel._history.length < 2) return

			var n = panel._history.length
			var stepX = w / (panel.maxPoints - 1)

			// ── Build point coordinates ──
			var pts = []
			for (var i = 0; i < n; i++) {
				pts.push({
					x: i * stepX,
					y: h - panel._history[i] * h
				})
			}

			// ── Gradient fill underneath ──
			ctx.beginPath()
			ctx.moveTo(pts[0].x, h)
			for (var j = 0; j < pts.length; j++)
				ctx.lineTo(pts[j].x, pts[j].y)
			ctx.lineTo(pts[pts.length - 1].x, h)
			ctx.closePath()

			var grad = ctx.createLinearGradient(0, 0, 0, h)
			var c = panel.lineColor
			grad.addColorStop(0, Qt.rgba(c.r, c.g, c.b, 0.15))
			grad.addColorStop(1, Qt.rgba(c.r, c.g, c.b, 0.0))
			ctx.fillStyle = grad
			ctx.fill()

			// ── Glow stroke (shadowBlur) ──
			ctx.beginPath()
			ctx.moveTo(pts[0].x, pts[0].y)
			for (var k = 1; k < pts.length; k++)
				ctx.lineTo(pts[k].x, pts[k].y)

			ctx.shadowBlur = 12
			ctx.shadowColor = panel.lineColor
			ctx.strokeStyle = panel.lineColor
			ctx.lineWidth = 1.8
			ctx.lineCap = "round"
			ctx.lineJoin = "round"
			ctx.stroke()
			ctx.shadowBlur = 0

			// ── Bright core (thinner, lighter) ──
			ctx.beginPath()
			ctx.moveTo(pts[0].x, pts[0].y)
			for (var m = 1; m < pts.length; m++)
				ctx.lineTo(pts[m].x, pts[m].y)

			ctx.strokeStyle = Qt.rgba(c.r, c.g, c.b, 0.9)
			ctx.lineWidth = 0.8
			ctx.stroke()

			// ── End-point dot (newest value) ──
			var last = pts[pts.length - 1]
			ctx.shadowBlur = 8
			ctx.shadowColor = panel.lineColor
			ctx.beginPath()
			ctx.arc(last.x, last.y, 3, 0, Math.PI * 2)
			ctx.fillStyle = panel.lineColor
			ctx.fill()
			ctx.shadowBlur = 0
		}
	}
}
