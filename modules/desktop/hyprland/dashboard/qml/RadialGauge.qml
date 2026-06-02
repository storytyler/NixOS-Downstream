import QtQuick

Canvas {
	id: canvas

	property real value: 0.5
	property color arcColor: "#7aa2f7"
	property color trackColor: "#1a1b26"
	property color textColor: "#c0caf5"
	property real lineWidth: 8

	implicitWidth: 160
	implicitHeight: 160

	onValueChanged: requestPaint()
	onArcColorChanged: requestPaint()
	onTrackColorChanged: requestPaint()

	onPaint: {
		var ctx = getContext("2d")
		ctx.reset()

		var cx = width / 2
		var cy = height / 2
		var radius = Math.max(1, Math.min(cx, cy) - lineWidth)
		var startRad = -Math.PI / 2
		var fullSweep = 2 * Math.PI
		var valueRad = startRad + fullSweep * value

		ctx.lineCap = "round"
		ctx.lineWidth = lineWidth

		ctx.beginPath()
		ctx.arc(cx, cy, radius, 0, 2 * Math.PI)
		ctx.strokeStyle = trackColor
		ctx.stroke()

		if (value > 0.001) {
			ctx.beginPath()
			ctx.arc(cx, cy, radius, startRad, valueRad)
			ctx.strokeStyle = arcColor
			ctx.stroke()
		}
	}

	Text {
		anchors.centerIn: parent
		text: Math.round(canvas.value * 100) + "%"
		color: canvas.textColor
		font.pointSize: 24
		font.family: "monospace"
		font.bold: true
	}
}
