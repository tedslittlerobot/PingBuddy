import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var pinger: PingerVM!

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        createMenuItem()
        pinger.ping()
        LauncherManager.launcher.enforceSavedOption()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        pinger.unsubscribe()
    }

    // MARK: - Helpers

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    func createMenuItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        pinger = PingerVM(settings: DefaultsSettingsVM())
        pinger.statusItem = statusBarItem

        let contentView = ContentView(pinger: pinger)
        popover = NSPopover()

        popover.contentSize = NSSize(width: 500, height: 650)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)

        if let button = statusBarItem.button {
             button.image = NSImage(named: "circle:blue")
             button.action = #selector(togglePopover(_:))
        }
    }
}
