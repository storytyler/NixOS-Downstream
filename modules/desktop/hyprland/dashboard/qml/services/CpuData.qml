import QtQuick
import Quickshell.Io

Item {
    id: cpuData

    property real usage: 0       // 0.0 – 1.0
    property real temp: 0        // °C

    // Internal: previous /proc/stat values for delta calculation
    property var _prevTotal: 0
    property var _prevIdle: 0

    // Poll CPU usage every 2s via FileView on /proc/stat
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            statProc.running = true
            tempProc.running = true
        }
    }

    // CPU usage from /proc/stat delta
    Process {
        id: statProc
        command: ["cat", "/proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                var line = this.text.split("\n")[0]  // "cpu  user nice system idle ..."
                var parts = line.trim().split(/\s+/)
                if (parts[0] !== "cpu") return
                // Sum all jiffies (skip "cpu" label)
                var total = 0
                for (var i = 1; i < parts.length; i++)
                    total += parseInt(parts[i]) || 0
                var idle = (parseInt(parts[4]) || 0) + (parseInt(parts[5]) || 0)  // idle + iowait

                if (cpuData._prevTotal > 0) {
                    var dTotal = total - cpuData._prevTotal
                    var dIdle = idle - cpuData._prevIdle
                    if (dTotal > 0)
                        cpuData.usage = Math.max(0, Math.min(1, 1.0 - dIdle / dTotal))
                }
                cpuData._prevTotal = total
                cpuData._prevIdle = idle
            }
        }
    }

    // CPU temperature from /sys/class/thermal/thermal_zone2/temp (x86_pkg_temp)
    Process {
        id: tempProc
        command: ["cat", "/sys/class/thermal/thermal_zone2/temp"]
        stdout: StdioCollector {
            onStreamFinished: {
                var val = parseInt(this.text.trim())
                if (!isNaN(val))
                    cpuData.temp = val / 1000.0  // millidegrees to °C
            }
        }
    }
}
