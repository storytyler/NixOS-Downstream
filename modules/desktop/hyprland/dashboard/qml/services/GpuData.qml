import QtQuick
import Quickshell.Io

Item {
    id: gpuData

    property real usage: 0         // 0.0 – 1.0
    property real temp: 0          // °C
    property real memoryUsedGB: 0  // used VRAM in GB
    property real memoryTotalGB: 0 // total VRAM in GB

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: gpuProc.running = true
    }

    Process {
        id: gpuProc
        command: [
            "nvidia-smi",
            "--query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total",
            "--format=csv,noheader,nounits"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                // Output: "58, 41, 4096, 8192"
                var parts = this.text.trim().split(", ")
                if (parts.length >= 2) {
                    gpuData.usage = Math.max(0, Math.min(1, (parseFloat(parts[0]) || 0) / 100.0))
                    gpuData.temp = parseFloat(parts[1]) || 0
                }
                if (parts.length >= 4) {
                    gpuData.memoryUsedGB = Math.round((parseFloat(parts[2]) || 0) / 1024 * 10) / 10
                    gpuData.memoryTotalGB = Math.round((parseFloat(parts[3]) || 0) / 1024 * 10) / 10
                }
            }
        }
    }
}
