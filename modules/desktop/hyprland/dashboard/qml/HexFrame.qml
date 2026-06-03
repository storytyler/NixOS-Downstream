import QtQuick

Canvas {
	id: canvas

	antialiasing: true

	property color borderColor: "#7aa2f7"
	property color glowColor: "#7aa2f7"
	property color backgroundColor: "transparent"
	property real borderWidth: 2.0
	property real glowWidth: 4.0
	property real glowOpacity: 0.3
	property bool flatTop: true
	property real _angleOffset: flatTop ? -Math.PI / 6 : 0

	implicitWidth: 200
	implicitHeight: 230

	onBorderColorChanged: requestPaint()
	onGlowColorChanged: requestPaint()
	onBackgroundColorChanged: requestPaint()
	onWidthChanged: requestPaint()
	onHeightChanged: requestPaint()

	function hexPath(ctx, cx, cy, r) {
		ctx.beginPath()
		for (var i = 0; i < 6; i++) {
			var angle = (i * Math.PI / 3) + canvas._angleOffset
			var xp = cx + r * Math.cos(angle)
			var yp = cy + r * Math.sin(angle)
			if (i === 0) ctx.moveTo(xp, yp)
			else ctx.lineTo(xp, yp)
		}
		ctx.closePath()
	}

	onPaint: {
		var ctx = getContext("2d")
		ctx.reset()

		var cx = width / 2
		var cy = height / 2
		var radius = Math.min(cx, cy) - canvas.glowWidth - 2
		if (radius <= 0) return

		hexPath(ctx, cx, cy, radius)
		ctx.fillStyle = canvas.backgroundColor.toString()
		ctx.fill()

		hexPath(ctx, cx, cy, radius)
		ctx.lineWidth = canvas.glowWidth
		ctx.strokeStyle = Qt.rgba(canvas.glowColor.r, canvas.glowColor.g,
			canvas.glowColor.b, canvas.glowOpacity)
		ctx.stroke()

		hexPath(ctx, cx, cy, radius)
		ctx.lineWidth = canvas.borderWidth
		ctx.strokeStyle = canvas.borderColor.toString()
		ctx.stroke()

		var innerR = radius - canvas.borderWidth - 3
		if (innerR > 0) {
			hexPath(ctx, cx, cy, innerR)
			ctx.lineWidth = 1
			ctx.strokeStyle = Qt.rgba(canvas.borderColor.r, canvas.borderColor.g,
				canvas.borderColor.b, 0.4)
			ctx.stroke()
		}

		for (var j = 0; j < 6; j++) {
			var angle = (j * Math.PI / 3) + canvas._angleOffset
			var ox = cx + radius * Math.cos(angle)
			var oy = cy + radius * Math.sin(angle)
			var ix = cx + (radius - 8) * Math.cos(angle)
			var iy = cy + (radius - 8) * Math.sin(angle)
			ctx.beginPath()
			ctx.moveTo(ox, oy)
			ctx.lineTo(ix, iy)
			ctx.lineWidth = 2
			ctx.strokeStyle = canvas.borderColor.toString()
			ctx.stroke()
		}
	}
}
