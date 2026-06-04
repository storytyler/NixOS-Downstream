import QtQuick
import Quickshell.Io

Item {
    id: sysInfo

    property real load1: 0
    property real load5: 0
    property real load15: 0
    property string uptime: ""
    property int processes: 0
    property int threads: 0

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            loadProc.running = true
            uptimeProc.running = true
        }
    }

    Process {
        id: loadProc
        command: ["cat", "/proc/loadavg"]
        stdout: StdioCollector {
            onStreamFinished: {
                var parts = this.text.trim().split(/\s+/)
                if (parts.length >= 4) {
                    sysInfo.load1 = parseFloat(parts[0]) || 0
                    sysInfo.load5 = parseFloat(parts[1]) || 0
                    sysInfo.load15 = parseFloat(parts[2]) || 0
                    // parts[3] is "running/total" processes
                    var procs = parts[3].split("/")
                    if (procs.length === 2)
                        sysInfo.threads = parseInt(procs[1]) || 0
                }
                // Total processes from /proc/stat — use nr_processes field
                // Actually /proc/loadavg gives running/total, where total = threads
                // For process count, we need a separate source. Skip for now.
            }
        }
    }

    Process {
        id: uptimeProc
        command: ["cat", "/proc/uptime"]
        stdout: StdioCollector {
            onStreamFinished: {
                var seconds = parseFloat(this.text.trim().split(/\s+/)[0]) || 0
                var days = Math.floor(seconds / 86400)
                var hours = Math.floor((seconds % 86400) / 3600)
                var mins = Math.floor((seconds % 3600) / 60)
                if (days > 0)
                    sysInfo.uptime = days + "d " + hours + "h"
                else if (hours > 0)
                    sysInfo.uptime = hours + "h " + mins + "m"
                else
                    sysInfo.uptime = mins + "m"
            }
        }
    }
}
