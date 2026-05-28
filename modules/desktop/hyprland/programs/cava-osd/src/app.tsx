import app from "ags/gtk4/app"
import { Astal } from "ags/gtk4"
import Cava from "gi://AstalCava"
import { CavaWidget } from "./CavaWidget"

app.start({
  main() {
    const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

    const cava = Cava.get_default()
    cava.bars = 32
    cava.framerate = 60
    cava.input = Cava.Input.PIPEWIRE
    cava.source = "auto"
    cava.autosens = true
    cava.stereo = false
    cava.noise_reduction = 0.77
    cava.active = true

    return (
      <window
        visible
        namespace="cava-osd"
        layer={Astal.Layer.OVERLAY}
        anchor={BOTTOM | LEFT | RIGHT}
        exclusivity={Astal.Exclusivity.IGNORE}
        margin_bottom={4}
        margin_left={2}
        margin_right={2}
        keymode={Astal.Keymode.NONE}
      >
        <CavaWidget />
      </window>
    )
  },
})
