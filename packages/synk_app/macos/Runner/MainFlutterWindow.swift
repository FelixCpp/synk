import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    ScreenMirrorPlugin.register(
      with: flutterViewController.registrar(forPlugin: "ScreenMirrorPlugin")
    )
    if #available(macOS 14.0, *) {
      IosMirrorPlugin.register(
        with: flutterViewController.registrar(forPlugin: "IosMirrorPlugin")
      )
    }
    IosHidPlugin.register(
      with: flutterViewController.registrar(forPlugin: "IosHidPlugin")
    )
    IosDeviceDiscoveryPlugin.register(
      with: flutterViewController.registrar(forPlugin: "IosDeviceDiscoveryPlugin")
    )

    super.awakeFromNib()
  }
}
