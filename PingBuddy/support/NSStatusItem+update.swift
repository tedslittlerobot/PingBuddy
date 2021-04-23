import Foundation
import SwiftUI

extension NSStatusItem {
    func update(from response: Pinger.Pong) {
        if response.status == .success {
            if let speed = response.speed {
                button?.image = speed.image

                return
            }
        }

        button?.image = response.status.image
    }
}
