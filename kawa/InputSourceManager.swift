import Carbon
import Cocoa

class InputSource {
  let tisInputSource: TISInputSource
  let icon: NSImage?

  var id: String {
    return tisInputSource.id
  }

  var name: String {
    return tisInputSource.name
  }

  init(tisInputSource: TISInputSource) {
    self.tisInputSource = tisInputSource

    var iconImage: NSImage? = nil

    if let imageURL = tisInputSource.iconImageURL {
      for url in [imageURL.retinaImageURL, imageURL.tiffImageURL, imageURL] {
        if let image = NSImage(contentsOf: url) {
          iconImage = image
          break
        }
      }
    }

    if iconImage == nil, let iconRef = tisInputSource.iconRef {
      iconImage = NSImage(iconRef: iconRef)
    }

    self.icon = iconImage
  }

  func select() {
    TISSelectInputSource(tisInputSource)
  }
}

extension InputSource: Equatable {
  static func == (lhs: InputSource, rhs: InputSource) -> Bool {
    return lhs.id == rhs.id
  }
}

extension InputSource {
  static var sources: [InputSource] {
    let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
    let inputSourceList = inputSourceNSArray as! [TISInputSource]

    return inputSourceList
      .filter {
        $0.category == TISInputSource.Category.keyboardInputSource && $0.isSelectable
    }.map {
      InputSource(tisInputSource: $0)
    }
  }
}

private extension URL {
  var retinaImageURL: URL {
    var components = pathComponents
    let filename: String = components.removeLast()
    let ext: String = pathExtension
    let retinaFilename = filename.replacingOccurrences(of: "." + ext, with: "@2x." + ext)
    return NSURL.fileURL(withPathComponents: components + [retinaFilename])!
  }

  var tiffImageURL: URL {
    return deletingPathExtension().appendingPathExtension("tiff")
  }
}
