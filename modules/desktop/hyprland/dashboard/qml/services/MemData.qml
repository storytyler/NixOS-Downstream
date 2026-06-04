import QtQuick
import Quickshell.Io

Item {
    id: memData

    property real usage: 0         // 0.0 – 1.0
    property real totalGB: 0       // total RAM in GB
    property real usedGB: 0        // used RAM in GB
    property real availableGB: 0   // available RAM in GB

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: memProc.running = true
    }

    Process {
        id: memProc
        command: ["cat", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.split("\n")
                var memTotal = 0, memAvailable = 0
                for (var i = 0; i < lines.length; i++) {
                    var parts = lines[i].split(":")
                    if (parts.length < 2) continue
                    var key = parts[0].trim()
                    var val = parseInt(parts[1].trim()) || 0  // in kB
                    if (key === "MemTotal") memTotal = val
                    else if (key === "MemAvailable") memAvailable = val
                }
                if (memTotal > 0) {
                    memData.totalGB = Math.round(memTotal / 1024 / 1024 * 10) / 10
                    memData.availableGB = Math.round(memAvailable / 1024 / 1024 * 10) / 10
                    memData.usedGB = Math.round((memTotal - memAvailable) / 1024 / 1024 * 10) / 10
                    memData.usage = Math.max(0, Math.min(1, 1.0 - memAvailable / memTotal))
                }
            }
        }
    }
}
