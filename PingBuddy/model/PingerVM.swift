import Foundation
import SwiftUI
import Combine

class PingerVM: ObservableObject {
    enum Status: String {
        case success
        case failure

        var image: NSImage {
            switch self {
                case .success:
                    return NSImage(named: "bang")!
                case .failure:
                    return NSImage(named: "bang")!
            }
        }
    }

    enum Speed: String {
        case fast
        case ok
        case slow
        case deathly

        static func from(time: TimeInterval) -> Speed {
            switch time {
                case let t where t < 0.01:
                    return fast
                case let t where t < 0.5:
                    return ok
                case let t where t < 1.0:
                    return slow
                default:
                    return deathly
            }
        }

        var image: NSImage {
            switch self {
                case .fast:
                    return NSImage(named: "circle:green")!
                case .ok:
                    return NSImage(named: "circle:blue")!
                case .slow:
                    return NSImage(named: "circle:amber")!
                case .deathly:
                    return NSImage(named: "circle:red")!
            }
        }
    }

    @ObservedObject var settings: PlainSettingsVM
    var pinger: SwiftyPing?
    var cancelObserver: AnyCancellable?
    let configuration = PingConfiguration(interval: 1, with: 0.2)

    var statusItem: NSStatusItem?

    @Published var active = false
    @Published var target: String?
    @Published var status: Status?
    @Published var duration: TimeInterval?
    @Published var speed: Speed?

    var humanDuration: String {
        guard let duration = duration else { return "n/a" }

        return String(format: "%.5f", duration)
    }

    init(settings: PlainSettingsVM) {
        self.settings = settings
    }

    func subscribe() -> PingerVM {
        if self.cancelObserver != nil {
            return self
        }

        self.cancelObserver = settings.objectWillChange
            .sink { _ in
                self.ping()
            }

        return self
    }

    func unsubscribe() {
        self.cancelObserver?.cancel()
    }

    func stop() {
        if let pinger = pinger {
            pinger.stopPinging()
            target = nil
            status = nil
            duration = nil
            speed = nil
        }
    }

    func ping() {
        ping(settings: settings)
    }

    func ping(settings: PlainSettingsVM) {
        stop()

        target = settings.target

        guard let target = target else { return }

        print("Pinging \(target)")

        do {
            self.pinger = try SwiftyPing(host: target, configuration: configuration, queue: DispatchQueue.global())
        } catch PingError.addressLookupError {
            print("Address Lookup Error: \(target)")

            status = .failure
            speed = nil
            duration = nil

            updateStatusItem()

            return
        } catch {
            print("Unhandled Error: \(error)")

            status = .failure
            speed = nil
            duration = nil

            updateStatusItem()

            return
        }

        guard let pinger = pinger else {
            print("Could not create pinger")
            return
        }

        pinger.observer = { response in
            DispatchQueue.main.async {
                self.status = .success
                self.duration = response.duration
                self.speed = .from(time: response.duration)
                print("⏱ \(self.duration!) [\(self.speed!)]")

                self.updateStatusItem()
            }
        }

        pinger.startPinging()
        active = true
    }

    func updateStatusItem() {
        if let button = statusItem?.button {
            if status != nil && status! == .failure {
                button.image = status?.image
            } else {
                button.image = speed?.image
            }
        }
    }
}
