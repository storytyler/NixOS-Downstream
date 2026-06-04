import QtQuick
import Quickshell.Io

Item {
    id: diskData

    property real totalGB: 0
    property real usedGB: 0
    property real readSpeed: 0      // bytes/sec
    property real writeSpeed: 0     // bytes/sec
    property string readFormatted: ""
    property string writeFormatted: ""

    property var _prevReadSectors: 0
    property var _prevWriteSectors: 0
    property var _prevTime: 0

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            diskStatsProc.running = true
            dfProc.running = true
        }
    }

    // Disk I/O from /proc/diskstats
    Process {
        id: diskStatsProc
        command: ["cat", "/proc/diskstats"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.split("\n")
                var now = Date.now()
                for (var i = 0; i < lines.length; i++) {
                    var parts = lines[i].trim().split(/\s+/)
                    // field 3 is device name, field 6 is sectors read, field 10 is sectors written
                    if (parts.length > 10 && parts[2] === "nvme0n1") {
                        var readSectors = parseInt(parts[5]) || 0
                        var writeSectors = parseInt(parts[9]) || 0

                        if (diskData._prevTime > 0) {
                            var dt = (now - diskData._prevTime) / 1000.0
                            if (dt > 0) {
                                var dRead = (readSectors - diskData._prevReadSectors) * 512  // sectors to bytes
                                var dWrite = (writeSectors - diskData._prevWriteSectors) * 512
                                diskData.readSpeed = Math.max(0, dRead / dt)
                                diskData.writeSpeed = Math.max(0, dWrite / dt)
                                diskData.readFormatted = formatBytes(diskData.readSpeed) + "/s"
                                diskData.writeFormatted = formatBytes(diskData.writeSpeed) + "/s"
                            }
                        }
                        diskData._prevReadSectors = readSectors
                        diskData._prevWriteSectors = writeSectors
                        diskData._prevTime = now
                        break
                    }
                }
            }
        }
    }

    // Disk space from df
    Process {
        id: dfProc
        command: ["df", "-B1", "/"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.split("\n")
                if (lines.length >= 2) {
                    var parts = lines[1].trim().split(/\s+/)
                    if (parts.length >= 4) {
                        diskData.totalGB = Math.round(parseInt(parts[1]) / 1073741824 * 10) / 10
                        diskData.usedGB = Math.round(parseInt(parts[2]) / 1073741824 * 10) / 10
                    }
                }
            }
        }
    }

    function formatBytes(b) {
        if (b < 1024) return Math.round(b) + " B"
        if (b < 1048576) return (b / 1024).toFixed(1) + " KB"
        return (b / 1048576).toFixed(1) + " MB"
    }
}
