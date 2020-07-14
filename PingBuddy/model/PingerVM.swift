import Foundation
import SwiftUI
import Combine

class PingerVM: ObservableObject {
    @ObservedObject var settings: PlainSettingsVM
    var cancelObserver: AnyCancellable?

    var statusItem: NSStatusItem?

    @Published var target: String?
    @Published var pong: Pinger.Pong?

    var pinger: Pinger?

    init(settings: PlainSettingsVM) {
        self.settings = settings
    }

    init(settings: PlainSettingsVM, pong: Pinger.Pong) {
        self.settings = settings
        self.pong = pong
    }

    func subscribe() -> PingerVM {
        if self.cancelObserver != nil {
            return self
        }

        self.cancelObserver = settings.objectWillChange
            .sink { _ in
                print("📺 | Settings Updated")
                self.ping()
            }

        return self
    }

    func unsubscribe() {
        self.cancelObserver?.cancel()
    }

    func ping() {
        ping(settings: settings)
    }

    func ping(settings: PlainSettingsVM) {
        ping(settings: settings.pingerSettings)
    }

    func ping(settings: Pinger.Settings) {
        if let pinger = pinger {
            pinger.stop()
        }

        pinger = Pinger(with: settings)

        pinger!.runIndefinitely { response in
            self.pong = response
            self.statusItem?.update(from: response)
        }
    }

    // MARK: - View Helpers

    var humanDuration: String {
        guard let duration = pong?.duration else { return "n/a" }

        return String(format: "%.5f", duration)
    }
}
