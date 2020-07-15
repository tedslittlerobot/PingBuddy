import Foundation
import SwiftUI

class Pinger: CustomStringConvertible {
    typealias PongHandler = ((Pong) -> Void)
    typealias StopHandler = (() -> Void)

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
