import Cocoa

class PermanentStorage {
  private static let defaults = UserDefaults.standard

  private enum StorageKey: String {
    case showsNotification = "show-notification"
    case launchedForTheFirstTime = "launched-for-the-first-time"
  }

  private static func bool(forKey key: StorageKey, default defaultValue: Bool) -> Bool {
    return defaults.object(forKey: key.rawValue) as? Bool ?? defaultValue
  }

  private static func set(_ value: Bool, forKey key: StorageKey) {
    defaults.set(value, forKey: key.rawValue)
  }

  static var showsNotification: Bool {
    get {
      return bool(forKey: .showsNotification, default: false)
    }
    set {
      set(newValue, forKey: .showsNotification)
    }
  }

  static var launchedForTheFirstTime: Bool {
    get {
      return bool(forKey: .launchedForTheFirstTime, default: true)
    }
    set {
      set(newValue, forKey: .launchedForTheFirstTime)
    }
  }
}
