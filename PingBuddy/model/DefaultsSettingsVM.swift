import Foundation
import SwiftUI

class DefaultsSettingsVM: PlainSettingsVM {
    let defaults = UserDefaults.standard

    init() {
        super.init(
            target: defaults.target,
            interval: defaults.interval,
            timeout: defaults.timeout,
            fastTime: defaults.fastTime,
            okTime: defaults.okTime,
            slowTime: defaults.slowTime
        )
    }

    override func save() {
        defaults.target = target
        defaults.set(interval: TimeInterval(interval))
        defaults.set(timeout: TimeInterval(timeout))
        defaults.set(fastTime: TimeInterval(fastTime))
        defaults.set(okTime: TimeInterval(okTime))
        defaults.set(slowTime: TimeInterval(slowTime))
    }
}
