import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let launcher = Launcher(uri: "com.tlr.PingBuddy", name: "PingBuddy")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("LAUNCHER RUNNING")
        launcher.run()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
