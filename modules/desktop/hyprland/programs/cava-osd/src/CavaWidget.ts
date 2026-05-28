import { Gtk, Gdk } from "ags/gtk4"
import Gsk from "gi://Gsk"
import Graphene from "gi://Graphene"
import Cava from "gi://AstalCava"

export class CavaWidget extends Gtk.Widget {
  static {
    Gtk.Widget.set_css_name.call(this, "cava")
  }

  private cava = Cava.get_default()!

  constructor(params?: any) {
    super(params)

    this.cava.connect("notify::values", () => {
      this.queue_draw()
    })
  }

  vfunc_snapshot(snapshot: Gtk.Snapshot): void {
    super.vfunc_snapshot(snapshot)

    const values = this.cava.get_values() as unknown as number[]
    const bars = this.cava.get_bars()

    if (!values || values.length === 0) return

    const width = this.get_allocated_width()
    const height = this.get_allocated_height()

    if (width <= 0 || height <= 0) return

    const color = this.get_color()

    const spacing = 4
    const barWidth = (width - spacing * (bars - 1)) / bars

    if (barWidth <= 0) return

    const pathBuilder = new Gsk.PathBuilder()

    for (let i = 0; i < values.length; i++) {
      const value = Math.min(values[i], 1.0)
      const barHeight = value * height
      const x = i * (barWidth + spacing)
      const y = height - barHeight

      pathBuilder.move_to(x, y)
      pathBuilder.line_to(x + barWidth, y)
      pathBuilder.line_to(x + barWidth, height)
      pathBuilder.line_to(x, height)
      pathBuilder.close()
    }

    const rgba = new Gdk.RGBA()
    rgba.red = color.red
    rgba.green = color.green
    rgba.blue = color.blue
    rgba.alpha = color.alpha * 0.8

    snapshot.append_fill(
      pathBuilder.to_path(),
      Gsk.FillRule.EVEN_ODD,
      rgba,
    )
  }
}
