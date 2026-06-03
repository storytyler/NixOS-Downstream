// DialGauge.qml — Compact animated radial dial gauge
// Uniform gray palette with spinning arcs, value arc, and glow
// Self-contained: single Canvas draws all layers in paint order
//
// Palette: #cfd3db (light) for value arc + text
//          #8f8f8f (mid)   for spinning arcs + glow
//          #6b6b6b (dark)  for panel border + track
import QtQuick

Item {
	id: gauge

	property string label: "CPU"
	property real value: 0.5               // 0.0 – 1.0
	property color lightColor: "#cfd3db"
	property color midColor: "#8f8f8f"
	property color darkColor: "#6b6b6b"

	// -- Single Canvas: all layers drawn in order --
	Canvas {
		id: gc
		anchors.fill: parent

		property real outerAngle: 0
		property real innerAngle: 0

		NumberAnimation on outerAngle {
			from: 0; to: 360; duration: 4000; loops: Animation.Infinite
		}
		NumberAnimation on innerAngle {
			from: 360; to: 0; duration: 6000; loops: Animation.Infinite
		}

		onOuterAngleChanged: requestPaint()
		onInnerAngleChanged: requestPaint()

		property real _val: gauge.value
		on_ValChanged: requestPaint()

		// Helper
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

		onPaint: {
			var ctx = getContext("2d")
			ctx.reset()
			var w = width, h = height
			var cx = w / 2, cy = h / 2
			var size = Math.min(cx, cy)

			// -- Layer 1: Dark transparent background --
			rr(ctx, 3, 3, w - 6, h - 6, 10)
			ctx.fillStyle = Qt.rgba(0.05, 0.06, 0.09, 0.5)
			ctx.fill()

			// -- Layer 2: Panel border with glow --
			ctx.shadowBlur = 18
			ctx.shadowColor = midColor.toString()
			ctx.strokeStyle = darkColor.toString()
			ctx.lineWidth = 1.5
			rr(ctx, 3, 3, w - 6, h - 6, 10)
			ctx.stroke()
			ctx.shadowBlur = 0

			// -- Radii (proportional to component size) --
			var outerR = Math.max(1, size - 8)
			var innerR = Math.max(1, size * 0.72)
			var valueR = Math.max(1, size * 0.5)

			// -- Layer 3: Outer spinning arcs (6 segments, CW) --
			var obase = outerAngle * Math.PI / 180
			ctx.shadowBlur = 6
			ctx.shadowColor = midColor.toString()
			ctx.strokeStyle = midColor.toString()
			ctx.lineWidth = 1.5
			ctx.lineCap = "round"
			for (var i = 0; i < 6; i++) {
				var a = obase + i * Math.PI / 3
				ctx.beginPath()
				ctx.arc(cx, cy, outerR, a, a + 0.4)
				ctx.stroke()
			}
			ctx.shadowBlur = 0

			// -- Layer 4: Inner spinning arcs (4 segments, CCW, subtle) --
			var ibase = innerAngle * Math.PI / 180
			ctx.strokeStyle = Qt.rgba(
				midColor.r, midColor.g, midColor.b, 0.35)
			ctx.lineWidth = 1
			for (var j = 0; j < 4; j++) {
				var b = ibase + j * Math.PI / 2
				ctx.beginPath()
				ctx.arc(cx, cy, innerR, b, b + 0.5)
				ctx.stroke()
			}

			// -- Layer 5: Value track (full circle, dim) --
			ctx.beginPath()
			ctx.arc(cx, cy, valueR, 0, 2 * Math.PI)
			ctx.strokeStyle = Qt.rgba(
				darkColor.r, darkColor.g, darkColor.b, 0.2)
			ctx.lineWidth = 4
			ctx.stroke()

			// -- Layer 6: Value arc (glow) --
			var v = gauge.value
			if (v > 0.001) {
				var s = -Math.PI / 2
				var e = s + 2 * Math.PI * v
				ctx.shadowBlur = 10
				ctx.shadowColor = lightColor.toString()
				ctx.beginPath()
				ctx.arc(cx, cy, valueR, s, e)
				ctx.strokeStyle = lightColor.toString()
				ctx.lineWidth = 4
				ctx.lineCap = "round"
				ctx.stroke()
				ctx.shadowBlur = 0
			}

			// -- Layer 7: Percentage text with glow --
			ctx.shadowBlur = 6
			ctx.shadowColor = lightColor.toString()
			ctx.fillStyle = lightColor.toString()
			ctx.font = "bold " + Math.round(Math.max(10, h * 0.16)) + "px monospace"
			ctx.textAlign = "center"
			ctx.textBaseline = "middle"
			ctx.fillText(Math.round(v * 100) + "%", cx, cy)
			ctx.shadowBlur = 0

			// -- Layer 8: Label text (above center) --
			ctx.shadowBlur = 0
			ctx.fillStyle = midColor.toString()
			ctx.font = Math.round(Math.max(8, h * 0.07)) + "px monospace"
			ctx.fillText(gauge.label, cx, cy - valueR + Math.max(6, h * 0.06))
		}
	}
}
