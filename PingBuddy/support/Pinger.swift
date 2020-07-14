import Foundation
import SwiftUI

class Pinger: CustomStringConvertible {
    typealias PongHandler = ((Pong) -> Void)
    typealias StopHandler = (() -> Void)

    struct Pong {
        let status: Status
        let target: String
        let duration: TimeInterval?
        let speed: Speed?
        let raw: PingResponse?

        static func failed(settings: Settings) -> Pong {
            return Pong(
                status: .failure,
                target: settings.target,
                duration: nil,
                speed: nil,
                raw: nil
            )
        }

        static func off(settings: Settings) -> Pong {
            return Pong(
                status: .off,
                target: settings.target,
                duration: nil,
                speed: nil,
                raw: nil
            )
        }

        static func from(response: PingResponse, settings: Settings) -> Pong {
            return Pong(
                status: .success,
                target: settings.target,
                duration: response.duration,
                speed: .from(time: response.duration, with: settings.timeBounds),
                raw: response
            )
        }

        static var sample = Pong(status: .success, target: "foobar", duration: 10, speed: .fast, raw: nil)
    }

    struct Settings {
        let target: String
        let interval: TimeInterval
        let timeout: TimeInterval
        let timeBounds: TimeBounds

        static var sample = Settings(target: "foobar", interval: 10, timeout: 20, timeBounds: TimeBounds(fast: 10, ok: 20, slow: 30))
    }

    struct TimeBounds {
        let fast: TimeInterval
        let ok: TimeInterval
        let slow: TimeInterval
    }

    enum Status: String {
        case success
        case failure
        case off

        var image: NSImage {
            switch self {
                case .success:
                    return NSImage(named: "bang")!
                case .failure:
                    return NSImage(named: "bang")!
                case .off:
                    return NSImage(named: "bang")!
            }
        }
    }

    enum Speed: String {
        case fast
        case ok
        case slow
        case deathly

        static func from(time: TimeInterval, with settings: TimeBounds) -> Speed {
            switch time {
                case let t where t < settings.fast:
                    return fast
                case let t where t < settings.ok:
                    return ok
                case let t where t < settings.slow:
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

    // MARK: - Properties

    let settings: Settings
    lazy var configuration: PingConfiguration = {
        return PingConfiguration(interval: settings.interval, with: settings.timeout)
    }()

    private var remaining = 0
    private var indefinitely = false
    private var stopHandler: StopHandler?

    // MARK: - Initialisers

    init(with: Settings) {
        settings = with
    }

    // MARK: - Runners

    func run(times: Int, handler: @escaping PongHandler) {
        remaining = times
        indefinitely = false

        run(handler: handler)
    }

    func runIndefinitely(handler: @escaping PongHandler) {
        indefinitely = true
        remaining = 0

        run(handler: handler)
    }

    func run(handler: @escaping PongHandler) {
        stopHandler = nil

        log("\(self) | Begin Running")

        handle(handler: handler)
    }

    private func handle(handler: @escaping PongHandler) {
        ping { response in
            handler(response)

            // If we should stop...
            if let stopHandler = self.stopHandler {
                stopHandler();
                self.log("\(self) | Stopped")

                return
            }

            // If we're counting, carry on counting
            if self.remaining > 0 {
                self.remaining -= 1
                self.log("\(self) | \(self.remaining) loops remaining")
            }

            if self.indefinitely || self.remaining > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.settings.interval) {
                    self.handle(handler: handler)
                }
            }
        }
    }

    // MARK: - Stoppers

    func stop() {
        stop {
            //
        }
    }

    func stop(handler: @escaping StopHandler) {
        log("\(self) | Stopping")

        stopHandler = {
            handler()
        }
    }

    // MARK: - Executors

    func makePinger() -> SwiftyPing? {
        do {
            return try SwiftyPing(host: settings.target, configuration: configuration, queue: DispatchQueue.global())
        } catch PingError.addressLookupError {
            log("Address Lookup Error: \(settings.target)")

            return nil
        } catch {
            log("Unhandled Error for \(settings.target): \(error)")

            return nil
        }
    }

    func ping(handler: @escaping PongHandler) {
        guard let pinger = makePinger() else {
            log("\(self) | Failure to Construct")

            handler(.failed(settings: settings))

            return
        }

        log("\(self) | Pinging")

        pinger.observer = { response in
            pinger.stopPinging()

            DispatchQueue.main.async {
                self.log("\(self) | Raw Response")

                handler(.from(response: response, settings: self.settings))
            }
        }

        pinger.targetCount = 1
        pinger.startPinging()
    }

    var description: String {
        return "🎾 \(settings.target)"
    }

    static var debug = false

    func log(_ string: String) {
        if Pinger.debug {
            print(string)
        }
    }
}
