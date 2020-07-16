
import Foundation

extension Pinger {
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
}
