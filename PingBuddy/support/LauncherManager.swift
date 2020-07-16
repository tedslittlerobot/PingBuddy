import Foundation
import ServiceManagement
import AppKit

struct LauncherManager {
    let uri: String

    static let launcher = LauncherManager(uri: "com.tlr.PingBuddyLauncher")

    func enforceSavedOption() {
        register(enabled: UserDefaults.standard.startAtLogin)
    }

    func register(enabled: Bool) {
        print("🚀 Registering launcher with status \(enabled)")

        SMLoginItemSetEnabled(uri as CFString, enabled)

        kill(if: targetAppIsRunning())
    }

    func targetAppIsRunning() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications

        return !runningApps.filter { $0.bundleIdentifier == uri }.isEmpty
    }

    func kill() {
        print("🚀 Killswitch Engaged")
        DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
    }

    func kill(if shouldKill: Bool) {
        if shouldKill {
            kill()
        }
    }
}
