import AppKit
import Foundation
import UserNotifications

enum NotificationManager {
  static func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .authorized, .provisional, .ephemeral:
        completion(true)
      case .notDetermined:
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
          completion(granted)
        }
      case .denied:
        completion(false)
      @unknown default:
        completion(false)
      }
    }
  }

  static func deliver(_ message: String, icon: NSImage?) {
    requestAuthorizationIfNeeded { granted in
      guard granted else { return }

      let content = UNMutableNotificationContent()
      content.body = message

      if let attachment = icon.flatMap(createAttachment(from:)) {
        content.attachments = [attachment]
      }

      let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: content,
        trigger: nil
      )

      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
  }

  private static func createAttachment(from image: NSImage) -> UNNotificationAttachment? {
    guard let url = writeImageToTemporaryLocation(image) else { return nil }
    return try? UNNotificationAttachment(identifier: "kawa-icon", url: url, options: nil)
  }

  private static func writeImageToTemporaryLocation(_ image: NSImage) -> URL? {
    guard
      let tiff = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let pngData = bitmap.representation(using: .png, properties: [:])
    else { return nil }

    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent("kawa-icon-\(UUID().uuidString).png")

    do {
      try pngData.write(to: url)
      return url
    } catch {
      return nil
    }
  }
}
