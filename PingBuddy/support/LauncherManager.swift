import Foundation
import ServiceManagement
import AppKit

struct LauncherManager {
    let uri: String

    func register() {
        SMLoginItemSetEnabled(uri as CFString, true)

        kill(if: appIsRunning())
    }

    func appIsRunning() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications

        return !runningApps.filter { $0.bundleIdentifier == uri }.isEmpty
    }

    func kill() {
        DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
    }

    func kill(if comparison: Bool) {
        if comparison {
            kill()
        }
    }
}
