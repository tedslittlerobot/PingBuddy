import Foundation

extension UserDefaults {
    static var defaultTarget = "8.8.8.8"
    static var defaultInterval = TimeInterval(1)
    static var defaultTimeout = TimeInterval(10)
    static var defaultFastTime = TimeInterval(0.001)
    static var defaultOkTime = TimeInterval(0.01)
    static var defaultSlowTime = TimeInterval(0.1)


    var target: String {
        get {
            string(forKey: "settings/target") ?? UserDefaults.defaultTarget
        }
        set {
            set(newValue, forKey: "settings/target")
        }
    }

    var interval: Double {
        has(key: "settings/interval") ? double(forKey: "settings/interval") : UserDefaults.defaultInterval
    }
    var timeout: Double {
        has(key: "settings/timeout") ? double(forKey: "settings/timeout") : UserDefaults.defaultTimeout
    }
    var fastTime: Double {
        has(key: "settings/fastTime") ? double(forKey: "settings/fastTime") : UserDefaults.defaultFastTime
    }
    var okTime: Double {
        has(key: "settings/okTime") ? double(forKey: "settings/okTime") : UserDefaults.defaultOkTime
    }
    var slowTime: Double {
        has(key: "settings/slowTime") ? double(forKey: "settings/slowTime") : UserDefaults.defaultSlowTime
    }

    func set(interval: TimeInterval?) {
        guard let interval = interval else { return }

        set(interval, forKey: "settings/interval")
    }
    func set(timeout: TimeInterval?) {
        guard let timeout = timeout else { return }

        set(timeout, forKey: "settings/timeout")
    }

    func set(fastTime: TimeInterval?) {
        guard let fastTime = fastTime else { return }

        set(fastTime, forKey: "settings/fastTime")
    }

    func set(okTime: TimeInterval?) {
        guard let okTime = okTime else { return }

        set(okTime, forKey: "settings/okTime")
    }

    func set(slowTime: TimeInterval?) {
        guard let slowTime = slowTime else { return }

        set(slowTime, forKey: "settings/slowTime")
    }
}
