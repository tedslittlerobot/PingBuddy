import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var window: NSWindow!

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var pinger: PingerVM!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // Create the SwiftUI view that provides the window contents.
        pinger = PingerVM(settings: DefaultsSettingsVM())
        pinger.statusItem = statusBarItem

        let contentView = ContentView(pinger: pinger)
        popover = NSPopover()

        popover.contentSize = NSSize(width: 500, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)

        if let button = statusBarItem.button {
             button.image = NSImage(named: "circle:blue")
             button.action = #selector(togglePopover(_:))
        }

        ping()
    }

    func ping() {
        pinger.subscribe().ping()
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

