import Foundation
import SwiftUI

extension Pinger {
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
}
