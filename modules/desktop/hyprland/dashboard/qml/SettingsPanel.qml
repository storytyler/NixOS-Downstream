import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
	id: panel

	anchors.left: parent.left
	anchors.top: parent.top
	anchors.bottom: parent.bottom
	width: 320
	color: "#99323232"
	visible: false

	property bool open: false
	property var root: null
	property var target: null

	function toggle() {
		open = !open
		visible = open
	}

	RowLayout {
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 16
		height: 40
		spacing: 12

		Text {
			text: "⚙"
			color: "#c0caf5"
			font.pointSize: 20
			MouseArea {
				anchors.fill: parent
				onClicked: panel.toggle()
			}
		}

		Text {
			text: "SETTINGS"
			color: "#c0caf5"
			font.pointSize: 18
			font.family: "monospace"
			font.bold: true
		}

		Item { Layout.fillWidth: true }
	}

	ColumnLayout {
		anchors.fill: parent
		anchors.topMargin: 60
		anchors.margins: 16
		spacing: 12

		Repeater {
			model: [
				{ name: "Background", prop: "bg" },
				{ name: "Primary", prop: "primary" },
				{ name: "Surface", prop: "surface" },
				{ name: "Text", prop: "textMain" },
				{ name: "Dim Text", prop: "textDim" }
			]

			ColumnLayout {
				Layout.fillWidth: true
				spacing: 4

				property var role: modelData

				Text {
					text: role.name
					color: "#565f89"
					font.pointSize: 10
					font.family: "monospace"
				}

				RowLayout {
					Layout.fillWidth: true
					spacing: 4

					Repeater {
						model: ["R", "G", "B"]

						RowLayout {
							spacing: 2

							Text {
								text: modelData
								color: "#3b3d57"
								font.pointSize: 8
								font.family: "monospace"
							}

							Slider {
								Layout.fillWidth: true
								from: 0
								to: 255
								stepSize: 1
								value: {
									var c = panel.target ? panel.target[role.prop] : "#000000"
									var idx = index
									if (idx === 0) return c.r * 255
									if (idx === 1) return c.g * 255
									return c.b * 255
								}
								onMoved: {
									if (!panel.target) return
									var c = panel.target[role.prop]
									var r = Math.round(c.r * 255)
									var g = Math.round(c.g * 255)
									var b = Math.round(c.b * 255)
									if (index === 0) r = Math.round(value)
									else if (index === 1) g = Math.round(value)
									else b = Math.round(value)
									panel.target[role.prop] = Qt.rgba(r / 255, g / 255, b / 255, c.a)
								}
							}
						}
					}
				}
			}
		}

		Item { Layout.fillHeight: true }
	}
}
