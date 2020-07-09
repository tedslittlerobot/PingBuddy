import Foundation
import SwiftUI

class DefaultsSettingsVM: PlainSettingsVM {
    init() {
        super.init(target: UserDefaults.standard.string(forKey: "target") ?? "8.8.8.8")
    }

    override func save() {
        UserDefaults.standard.set(target, forKey: "target")
    }
}
