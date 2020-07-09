import Foundation
import SwiftUI

class PlainSettingsVM: ObservableObject {
    var target: String {
        didSet {
            objectWillChange.send()
            save()
        }
    }

    init(target: String) {
        self.target = target
    }

    func save() {
        //
    }
}
