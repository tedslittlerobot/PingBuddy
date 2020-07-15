import Foundation
import AppKit

class Launcher {
    let uri: String
    let name: String

    init(uri: String, name: String) {
        self.uri = uri
        self.name = name
    }

    @objc func terminate() {
        NSApp.terminate(nil)
    }

    func listen() {
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: uri)
    }

    func appIsRunning() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications

        return !runningApps.filter { $0.bundleIdentifier == uri }.isEmpty
    }

    func run() {
        if appIsRunning() {
            // If the app is already running, we don't need a launcher!
            terminate()
        } else {
            // Listen for the remote kill command
            listen()
            // Launch the main app!
            launch()
        }
    }

    func launch() {
        let path = Bundle.main.bundlePath as NSString
        var components = path.pathComponents
        components.removeLast()
        components.removeLast()
        components.removeLast()
        components.append("MacOS")
        components.append(name) //main app name

        let newPath = NSString.path(withComponents: components)

        NSWorkspace.shared.launchApplication(newPath)
    }
}
