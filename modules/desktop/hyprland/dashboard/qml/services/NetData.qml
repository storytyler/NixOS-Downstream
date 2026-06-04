import QtQuick
import Quickshell.Io

Item {
    id: netData

    property real downloadSpeed: 0    // bytes/sec (from wlp5s0)
    property real uploadSpeed: 0      // bytes/sec (from wlp5s0)
    property string downloadFormatted: "0 B/s"
    property string uploadFormatted: "0 B/s"

    property var _prevRx: ({})
    property var _prevTx: ({})
    property var _prevTime: 0

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: netProc.running = true
    }

    Process {
        id: netProc
        command: ["cat", "/proc/net/dev"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.split("\n")
                var now = Date.now()
                var rxTotal = 0, txTotal = 0

                for (var i = 2; i < lines.length; i++) {
                    var parts = lines[i].trim().split(":")
                    if (parts.length < 2) continue
                    var iface = parts[0].trim()
                    var nums = parts[1].trim().split(/\s+/)
                    // Only count active interfaces: wlp5s0 and tailscale0
                    if (iface !== "wlp5s0" && iface !== "tailscale0") continue
                    rxTotal += parseInt(nums[0]) || 0  // receive bytes
                    txTotal += parseInt(nums[8]) || 0  // transmit bytes
                }

                if (netData._prevTime > 0) {
                    var dt = (now - netData._prevTime) / 1000.0  // seconds
                    if (dt > 0) {
                        var dRx = rxTotal - (netData._prevRx.total || 0)
                        var dTx = txTotal - (netData._prevTx.total || 0)
                        netData.downloadSpeed = Math.max(0, dRx / dt)
                        netData.uploadSpeed = Math.max(0, dTx / dt)
                        netData.downloadFormatted = formatBytes(netData.downloadSpeed) + "/s"
                        netData.uploadFormatted = formatBytes(netData.uploadSpeed) + "/s"
                    }
                }

                netData._prevRx = { total: rxTotal }
                netData._prevTx = { total: txTotal }
                netData._prevTime = now
            }
        }
    }

    function formatBytes(b) {
        if (b < 1024) return Math.round(b) + " B"
        if (b < 1048576) return (b / 1024).toFixed(1) + " KB"
        return (b / 1048576).toFixed(1) + " MB"
    }
}
