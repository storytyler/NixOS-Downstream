import Quickshell
import QtQuick

FloatingWindow {
	id: root

	title: "Dashboard"
	fullscreen: true
	color: "#991f1f1f"

	SettingsPanel {
		id: settingsPanel
	}

	Text {
		anchors.centerIn: parent
		text: "DASHBOARD"
		color: "#c0caf5"
		font.pointSize: 48
		font.family: "monospace"
	}
}
