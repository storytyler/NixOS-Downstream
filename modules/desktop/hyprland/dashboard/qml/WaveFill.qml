import QtQuick

Canvas {
	id: canvas

	antialiasing: true

	property real value: 0.5
	property color fillColor: "#7aa2f7"
	property color fillGradientEnd: "#3b4261"
	property real waveAmplitude: 3.0
	property real waveFrequency: 1.5
	property real waveSpeed: 1400
	property bool hexClip: false
	property bool hexFlatTop: true
	property real _phase: 0.0
	property real _angleOffset: hexFlatTop ? -Math.PI / 6 : 0

	implicitWidth: 120
	implicitHeight: 160

	onValueChanged: requestPaint()
	onWidthChanged: requestPaint()
	onHeightChanged: requestPaint()
	onFillColorChanged: requestPaint()

	NumberAnimation on _phase {
		from: 0
		to: Math.PI * 2
		duration: canvas.waveSpeed
		loops: Animation.Infinite
		running: canvas.visible && canvas.value > 0.001
	}
	on_PhaseChanged: requestPaint()

	onPaint: {
		var ctx = getContext("2d")
		ctx.reset()

		if (canvas.value <= 0.001) return

		var cx = width / 2
		var cy = height / 2

		if (canvas.hexClip) {
			var hexR = Math.min(cx, cy) - 1
			ctx.beginPath()
			for (var h = 0; h < 6; h++) {
				var hAngle = (h * Math.PI / 3) + canvas._angleOffset
				var hx = cx + hexR * Math.cos(hAngle)
				var hy = cy + hexR * Math.sin(hAngle)
				if (h === 0) ctx.moveTo(hx, hy)
				else ctx.lineTo(hx, hy)
			}
			ctx.closePath()
			ctx.clip()
		}

		var waterY = height * (1 - canvas.value)

		ctx.beginPath()
		ctx.moveTo(0, height)
		ctx.lineTo(0, waterY)

		var segs = Math.max(8, Math.floor(width))
		for (var i = 0; i <= segs; i++) {
			var x = i * (width / segs)
			var y = waterY + Math.sin(
				(i / segs) * Math.PI * 2 * canvas.waveFrequency + canvas._phase
			) * canvas.waveAmplitude
			ctx.lineTo(x, y)
		}

		ctx.lineTo(width, height)
		ctx.closePath()

		var grad = ctx.createLinearGradient(0, waterY, 0, height)
		grad.addColorStop(0, canvas.fillColor.toString())
		grad.addColorStop(1, canvas.fillGradientEnd.toString())
		ctx.fillStyle = grad
		ctx.fill()
	}
}
