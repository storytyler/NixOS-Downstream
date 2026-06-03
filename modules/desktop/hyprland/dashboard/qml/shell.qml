import Quickshell
import QtQuick

FloatingWindow {
	id: root

	title: "Dashboard"
	fullscreen: true

	PersistentProperties {
		id: saved
		reloadableId: "dashboardColors"

		property color bg: "#991f1f1f"
		property color primary: "#7aa2f7"
		property color surface: "#1a1b26"
		property color textMain: "#c0caf5"
		property color textDim: "#565f89"
	}

	color: saved.bg

	SettingsPanel {
		id: settingsPanel
		target: saved
	}

	Text {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.margins: 12
		text: "⚙"
		color: saved.textDim
		font.pointSize: 20
		visible: !settingsPanel.visible
		MouseArea {
			anchors.fill: parent
			onClicked: settingsPanel.toggle()
		}
	}

	Text {
		anchors.centerIn: parent
		text: "DASHBOARD"
		color: saved.textMain
		font.pointSize: 48
		font.family: "monospace"
	}

	Row {
		anchors.centerIn: parent
		anchors.verticalCenterOffset: 140
		spacing: 40

		Item {
			width: 200
			height: 230

			HexFrame {
				anchors.fill: parent
				borderColor: "#f7768e"
				glowColor: "#f7768e"
				backgroundColor: Qt.rgba(0.1, 0.1, 0.15, 0.6)
				glowOpacity: 0.25
			}

			RadialGauge {
				anchors.fill: parent
				anchors.margins: 14
				value: 0.58
				arcColor: "#f7768e"
				trackColor: "transparent"
				textColor: saved.textMain
			}

			Text {
				anchors.top: parent.top
				anchors.topMargin: 24
				anchors.horizontalCenter: parent.horizontalCenter
				text: "GPU"
				color: saved.textDim
				font.pointSize: 11
				font.family: "monospace"
			}
		}
	}
}
