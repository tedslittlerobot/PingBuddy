import Foundation
import SwiftUI

class SettingsVM: ObservableObject {
//    @Published var target: String

    var target: String {
        willSet {
            objectWillChange.send()
        }

        didSet {
            print("changed target to \(target)!")
        }
    }

    init(target: String) {
        self.target = target
    }

    func save() {
        //
    }
}
