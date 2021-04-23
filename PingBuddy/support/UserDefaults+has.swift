import Foundation

extension UserDefaults {
    func has(key: String) -> Bool {
        return string(forKey: key) != nil
    }
}
