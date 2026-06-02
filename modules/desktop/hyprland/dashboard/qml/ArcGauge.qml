import QtQuick

Canvas {
	id: canvas

	property real value: 0.5
	property color arcColor: "#7aa2f7"
	property color trackColor: "#1a1b26"
	property color textColor: "#c0caf5"
	property real lineWidth: 8
	property real startAngle: -225
	property real sweepAngle: 270

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
		var startRad = startAngle * Math.PI / 180
		var sweepRad = sweepAngle * Math.PI / 180
		var valueRad = startRad + sweepRad * value

		ctx.lineCap = "round"
		ctx.lineWidth = lineWidth

		ctx.beginPath()
		ctx.arc(cx, cy, radius, startRad, startRad + sweepRad)
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
