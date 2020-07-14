import Foundation
import SwiftUI

class PlainSettingsVM: ObservableObject {
    var target: String {
        didSet {
            objectWillChange.send()
            save()
        }
    }

    var interval: String {
        didSet {
            objectWillChange.send()
            save()
        }
    }

    var timeout: String {
        didSet {
            objectWillChange.send()
            save()
        }
    }

    var fastTime: String {
        didSet {
            objectWillChange.send()
            save()
        }
    }

    var okTime: String {
        didSet {
            objectWillChange.send()
            save()
        }
    }

    var slowTime: String {
        didSet {
            objectWillChange.send()
            save()
        }
    }

    init(
        target: String,
        interval: TimeInterval,
        timeout: TimeInterval,
        fastTime: TimeInterval,
        okTime: TimeInterval,
        slowTime: TimeInterval
    ) {
        self.target = target
        self.interval = String(interval)
        self.timeout = String(timeout)
        self.fastTime = String(fastTime)
        self.okTime = String(okTime)
        self.slowTime = String(slowTime)
    }

    func save() {
        //
    }

    func reset() {
        target = UserDefaults.defaultTarget
        interval = String(UserDefaults.defaultInterval)
        timeout = String(UserDefaults.defaultTimeout)
        fastTime = String(UserDefaults.defaultFastTime)
        okTime = String(UserDefaults.defaultOkTime)
        slowTime = String(UserDefaults.defaultSlowTime)
    }

    var pingerSettings: Pinger.Settings {
        return Pinger.Settings(
            target: target,
            interval: TimeInterval(interval) ?? UserDefaults.defaultInterval,
            timeout: TimeInterval(timeout) ?? UserDefaults.defaultTimeout,
            timeBounds: Pinger.TimeBounds(
                fast: TimeInterval(fastTime) ?? UserDefaults.defaultFastTime,
                ok: TimeInterval(okTime) ?? UserDefaults.defaultOkTime,
                slow: TimeInterval(slowTime) ?? UserDefaults.defaultSlowTime
            )
        )
    }

    static var sample: PlainSettingsVM {
        PlainSettingsVM(
            target: "foobar", interval: 1, timeout: 2, fastTime: 3, okTime: 4, slowTime: 5
        )
    }
}
