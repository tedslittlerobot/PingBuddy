import Foundation

extension Pinger {
    struct Settings {
        let target: String
        let interval: TimeInterval
        let timeout: TimeInterval
        let timeBounds: TimeBounds

        static var sample = Settings(target: "foobar", interval: 10, timeout: 20, timeBounds: TimeBounds(fast: 10, ok: 20, slow: 30))
    }
}
