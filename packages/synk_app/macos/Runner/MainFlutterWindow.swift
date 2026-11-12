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
    IosMediaStreamPlugin.register(
      with: flutterViewController.registrar(forPlugin: "IosMediaStreamPlugin")
    )
    IosHidPlugin.register(
      with: flutterViewController.registrar(forPlugin: "IosHidPlugin")
    )
    IosDeviceDiscoveryPlugin.register(
      with: flutterViewController.registrar(forPlugin: "IosDeviceDiscoveryPlugin")
    )

    acceptFirstMouseInOverlays()

    super.awakeFromNib()
  }

  private func acceptFirstMouseInOverlays() {
    let selector = #selector(NSView.acceptsFirstMouse(for:))
    let acceptsFirstMouse: @convention(block) (NSView, NSEvent?) -> Bool = { _, _ in true }
    let implementation = imp_implementationWithBlock(acceptsFirstMouse)

    for className in [
      "desktop_drop.DropTarget",
      "macos_window_utils.ForwardingView",
      "macos_window_utils.PassthroughView",
    ] {
      guard let viewClass = NSClassFromString(className),
        let method = class_getInstanceMethod(NSView.self, selector)
      else {
        continue
      }

      class_replaceMethod(viewClass, selector, implementation, method_getTypeEncoding(method))
    }
  }
}
