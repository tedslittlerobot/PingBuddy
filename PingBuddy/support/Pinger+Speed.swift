import Foundation
import SwiftUI

extension Pinger {
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
}
