import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
	id: panel

	anchors.left: parent.left
	anchors.top: parent.top
	anchors.bottom: parent.bottom
	width: 320
	color: "#cc111122"

	ColumnLayout {
		anchors.fill: parent
		anchors.margins: 20
		spacing: 16

		Text {
			text: "SETTINGS"
			color: "#c0caf5"
			font.pointSize: 18
			font.family: "monospace"
			font.bold: true
		}

		Text {
			text: "Panel loaded successfully"
			color: "#565f89"
			font.pointSize: 12
			font.family: "monospace"
		}
	}
}
