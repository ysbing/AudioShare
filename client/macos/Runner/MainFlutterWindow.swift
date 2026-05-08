import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // Fixed size — matches Flutter UI: SizedBox(width:360, height:540) + checkbox row.
    let contentSize = NSSize(width: 360, height: 560)
    self.setContentSize(contentSize)
    self.styleMask.remove(.resizable)
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}
