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

	ArcGauge {
		anchors.centerIn: parent
		anchors.verticalCenterOffset: 120
		value: 0.73
		arcColor: saved.primary
		trackColor: saved.surface
		textColor: saved.textMain
	}
}
