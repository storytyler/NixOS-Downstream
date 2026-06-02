import Quickshell
import Quickshell.Hyprland
import QtQuick

ShellWindow {
	id: root

	// Hyprland workspace assignment
	HyprlandWindow {
		id: hw
		identifier: "dashboard"
	}

	// Window properties
	width: 1920
	height: 1080
	color: "transparent"
	visible: true

	// Fullscreen on Hyprland via QML
	// Window rules in Hyprland handle the rest (no borders, no shadows)
	Component.onCompleted: {
		console.log("Dashboard loaded on workspace 10");
	}

	// Placeholder — just a label to confirm rendering
	Text {
		anchors.centerIn: parent
		text: "DASHBOARD"
		color: "#c0caf5"
		font.pointSize: 48
		font.family: "monospace"
	}
}
