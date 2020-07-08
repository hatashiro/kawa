import Cocoa

class Storage {
  private static func object<T>(forKey key: StorageKey, withDefault defaultValue: T) -> T {
    if let val = UserDefaults.standard.object(forKey: key.rawValue) as? T {
      return val
    } else {
      return defaultValue
    }
  }

  private static func set<T>(_ value: T, forKey key: StorageKey) {
    UserDefaults.standard.set((value as AnyObject), forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }

  private enum StorageKey: String {
    case showsNotification = "show-notification"
    case launchedForTheFirstTime = "launched-for-the-first-time"
  }

  static var showsNotification: Bool {
    get {
      return object(forKey: .showsNotification, withDefault: false)
    }
    set {
      set(newValue, forKey: .showsNotification)
    }
  }

  static var launchedForTheFirstTime: Bool {
    get {
      return object(forKey: .launchedForTheFirstTime, withDefault: true)
    }
    set {
      set(newValue, forKey: .launchedForTheFirstTime)
    }
  }
}
