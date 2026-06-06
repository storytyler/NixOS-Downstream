// DialGauge.qml — Compact animated radial dial gauge
// Neutral ramp: all layers brighten N1→N5 as value rises
// Dual arc layers: outer staggered (collecting) + inner counter-rotating
// Visual detail: tick marks, cardinal marks, double-stroke value glow
// Configurable patterns: segment counts, arc lengths, speeds, directions
// Performance: single Timer at 30fps, Canvas.FramebufferObject + MultiEffect GPU glow
import QtQuick
import QtQuick.Effects

Item {
	id: gauge

	property string label: "CPU"
	property real value: 0.5               // 0.0 – 1.0
	property real temp: 0                   // °C, 0 = not available

	// Neutral ramp (matugen-ready)
	property color n1: "#1f1f1f"   // Background. Deep neutral black.
	property color n2: "#323232"   // Inactive borders, panel fills.
	property color n3: "#6b6b6b"   // Secondary text, comments, separators.
	property color n4: "#8f8f8f"   // Dim highlights, alternate rows.
	property color n5: "#cfd3db"   // Primary text. Cool-tinted dim white.

	// Arc configuration (for visual desync between instances)
	property int arcCount: 6          // number of arc segments
	property real arcLen: 0.4         // arc length in radians
	property real baseSpeed: 3        // base degrees per tick
	property int arcDir: 1            // 1=CW, -1=CCW

	property int innerCount: 4          // number of inner arc segments
	property real innerArcLen: 0.5      // arc length in radians
	property real innerBaseSpeed: 2     // base degrees per tick
	property int innerDir: -1           // 1=CW, -1=CCW

	// Spinning arc angle (driven by Timer below)
	property real _arcAngle: 0
	property real _innerAngle: 0

	// Computed active color from neutral ramp
	property color _activeColor: n3
	onValueChanged: _activeColor = _lerp(n3, n5, value)

	// Circle center (left-aligned, updated on paint)
	property real _circleX: 0
	property real _circleY: 0

	function _lerp(c1, c2, t) {
		return Qt.rgba(
			c1.r + (c2.r - c1.r) * t,
			c1.g + (c2.g - c1.g) * t,
			c1.b + (c2.b - c1.b) * t,
			1.0
		)
	}

	// 30fps timer — dynamic speed based on value
	Timer {
		interval: 33
		running: true
		repeat: true
		onTriggered: {
			var speedFactor = 0.3 + gauge.value * 1.7
			gauge._arcAngle = (gauge._arcAngle + gauge.arcDir * gauge.baseSpeed * speedFactor + 360) % 360
			gauge._innerAngle = (gauge._innerAngle + gauge.innerDir * gauge.innerBaseSpeed * speedFactor + 360) % 360
			dialCanvas.requestPaint()
		}
	}

	// Single Canvas: all layers in paint order
	Canvas {
		id: dialCanvas
		anchors.fill: parent
		renderStrategy: Canvas.Threaded
		renderTarget: Canvas.FramebufferObject
		layer.enabled: true
		layer.effect: MultiEffect {
			shadowEnabled: true
			shadowColor: gauge._activeColor
			shadowBlur: 0.5
			shadowOpacity: 0.3
		}

		property real _val: gauge.value
		on_ValChanged: requestPaint()

		onPaint: {
			var ctx = getContext("2d")
			ctx.reset()
			var w = width, h = height
			var cy = h / 2
			var size = Math.min(cy, w) - 8
			var cx = size + 4
			gauge._circleX = cx
			gauge._circleY = cy
			var v = gauge.value
			var ac = gauge._activeColor   // lerp(n3, n5, value)

			var valueR = Math.max(1, size * 0.5)
			var innerR = Math.max(1, size * 0.72)
			var edgeR = Math.max(1, size - 8)

			// ═══ Layer 1: Outer staggered arcs (collecting toward edge) ═══
			// Each segment at unique radius, converging toward edgeR as value rises
			// Color: per-segment gradient from N1 (inner) to N4 (outer), all brighten to N5 with value
			var abase = gauge._arcAngle * Math.PI / 180
			ctx.lineCap = "round"
			ctx.lineWidth = 1.5
			for (var i = 0; i < gauge.arcCount; i++) {
				var fraction = gauge.arcCount > 1 ? i / (gauge.arcCount - 1) : 0.5
				var baseR = valueR + 8 + (edgeR - valueR - 8) * fraction
				var currentR = baseR + (edgeR - baseR) * v
				var baseColor = gauge._lerp(gauge.n1, gauge.n4, fraction)
				var segColor = gauge._lerp(baseColor, gauge.n5, v)
				var a = abase + i * (2 * Math.PI / gauge.arcCount)
				ctx.beginPath()
				ctx.arc(cx, cy, Math.max(1, currentR), a, a + gauge.arcLen)
				ctx.strokeStyle = segColor.toString()
				ctx.stroke()
			}

			// ═══ Layer 2: Inner counter-rotating arcs ═══
			// Fixed radius, subtle opacity (0.5), same N1→N5 color gradient
			var ibase = gauge._innerAngle * Math.PI / 180
			var innerColor = gauge._lerp(gauge.n2, gauge.n4, v)
			ctx.strokeStyle = Qt.rgba(innerColor.r, innerColor.g, innerColor.b, 0.5)
			ctx.lineWidth = 1
			ctx.lineCap = "round"
			for (var j = 0; j < gauge.innerCount; j++) {
				var b = ibase + j * (2 * Math.PI / gauge.innerCount)
				ctx.beginPath()
				ctx.arc(cx, cy, innerR, b, b + gauge.innerArcLen)
				ctx.stroke()
			}

			// ═══ Layer 3: Tick marks around value track ═══
			// 24 small dots evenly spaced around valueR, very subtle
			var tickColor = gauge._lerp(gauge.n2, gauge.n3, v * 0.5)
			ctx.fillStyle = Qt.rgba(tickColor.r, tickColor.g, tickColor.b, 0.3)
			for (var t = 0; t < 24; t++) {
				var ta = t * (2 * Math.PI / 24)
				var tx = cx + Math.cos(ta) * valueR
				var ty = cy + Math.sin(ta) * valueR
				ctx.beginPath()
				ctx.arc(tx, ty, 1, 0, Math.PI * 2)
				ctx.fill()
			}

			// ═══ Layer 4: Cardinal marks (12/3/6/9 o'clock) ═══
			// Slightly larger dots at 4 cardinal positions, brighter
			var cardColor = gauge._lerp(gauge.n3, gauge.n5, v * 0.7)
			ctx.fillStyle = Qt.rgba(cardColor.r, cardColor.g, cardColor.b, 0.4)
			for (var c = 0; c < 4; c++) {
				var ca = c * Math.PI / 2 - Math.PI / 2
				var cardx = cx + Math.cos(ca) * valueR
				var cardy = cy + Math.sin(ca) * valueR
				ctx.beginPath()
				ctx.arc(cardx, cardy, 2, 0, Math.PI * 2)
				ctx.fill()
			}

			// ═══ Layer 5: Value track (full circle, near-invisible) ═══
			ctx.beginPath()
			ctx.arc(cx, cy, valueR, 0, 2 * Math.PI)
			ctx.strokeStyle = Qt.rgba(ac.r, ac.g, ac.b, 0.06)
			ctx.lineWidth = 2
			ctx.stroke()

			// ═══ Layer 6: Value arc with double-stroke glow ═══
			if (v > 0.001) {
				var s = -Math.PI / 2
				var e = s + 2 * Math.PI * v
				// Glow pass
				ctx.beginPath()
				ctx.arc(cx, cy, valueR, s, e)
				ctx.strokeStyle = Qt.rgba(ac.r, ac.g, ac.b, 0.25)
				ctx.lineWidth = 12
				ctx.lineCap = "round"
				ctx.stroke()
				// Core pass
				ctx.beginPath()
				ctx.arc(cx, cy, valueR, s, e)
				ctx.strokeStyle = ac.toString()
				ctx.lineWidth = 4
				ctx.lineCap = "round"
				ctx.stroke()
			}

		}
	}

	// Percentage text (follows circle center, left-aligned)
	Text {
		id: percentText
		x: gauge._circleX - width / 2
		y: gauge._circleY - height / 2
		text: Math.round(gauge.value * 100) + "%"
		color: gauge._activeColor
		font.pixelSize: Math.max(10, Math.min(dialCanvas.height * 0.18, dialCanvas.width * 0.14))
		font.family: "monospace"
		font.bold: true
		style: Text.Raised
		styleColor: Qt.rgba(gauge._activeColor.r, gauge._activeColor.g, gauge._activeColor.b, 0.3)
	}

	// Label beneath percentage (follows circle center)
	Text {
		id: labelText
		x: gauge._circleX - width / 2
		anchors.top: percentText.bottom
		anchors.topMargin: font.pixelSize * 0.2
		text: gauge.label
		color: gauge._activeColor
		font.pixelSize: Math.max(7, Math.min(dialCanvas.height * 0.06, dialCanvas.width * 0.05))
		font.family: "monospace"
	}


}
