import QtQuick
import Quickshell.Io

Item {
    id: signalData

    property real latency: 0          // ms
    property int strength: 0          // 0-4 bars
    property string strengthFormatted: "· · · · ·"

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: pingProc.running = true
    }

    Process {
        id: pingProc
        command: ["ping", "-c", "1", "-W", "3", "1.1.1.1"]
        stdout: StdioCollector {
            onStreamFinished: {
                // Parse "time=8.42 ms" from ping output
                var match = this.text.match(/time=([\d.]+)\s*ms/)
                if (match) {
                    signalData.latency = parseFloat(match[1])
                    // Map latency to bars: <5ms=4, <15ms=3, <30ms=2, <60ms=1, else=0
                    if (signalData.latency < 5) signalData.strength = 4
                    else if (signalData.latency < 15) signalData.strength = 3
                    else if (signalData.latency < 30) signalData.strength = 2
                    else if (signalData.latency < 60) signalData.strength = 1
                    else signalData.strength = 0
                } else {
                    signalData.latency = 999
                    signalData.strength = 0
                }
                // Build visual string: filled squares for strength, empty for rest
                var filled = "■".repeat(signalData.strength)
                var empty = "□".repeat(4 - signalData.strength)
                signalData.strengthFormatted = filled + empty + " " + Math.round(signalData.latency) + "ms"
            }
        }
    }
}
