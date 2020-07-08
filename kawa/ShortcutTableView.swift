import Cocoa

class ShortcutTableView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return InputSource.sources.count
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let identifier = convertFromNSUserInterfaceItemIdentifier(tableColumn!.identifier)
    let inputSource = InputSource.sources[row]

    if identifier == "Keyboard" {
      return createKeyboardCellView(tableView, inputSource)
    } else if identifier == "Shortcut" {
      return createShorcutCellView(tableView, inputSource)
    }

    return nil
  }

  func createKeyboardCellView(_ tableView: NSTableView, _ inputSource: InputSource) -> NSTableCellView? {
    let cell = tableView.makeView(withIdentifier: convertToNSUserInterfaceItemIdentifier("KeyboardCellView"), owner: self) as? NSTableCellView
    cell!.textField?.stringValue = inputSource.name
    cell!.imageView?.image = inputSource.icon
    return cell
  }

  func createShorcutCellView(_ tableView: NSTableView, _ inputSource: InputSource) -> ShortcutCellView? {
    let cell = tableView.makeView(withIdentifier: convertToNSUserInterfaceItemIdentifier("ShortcutCellView"), owner: self) as? ShortcutCellView
    cell?.setInputSource(inputSource)
    return cell
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSUserInterfaceItemIdentifier(_ input: NSUserInterfaceItemIdentifier) -> String {
  return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSUserInterfaceItemIdentifier(_ input: String) -> NSUserInterfaceItemIdentifier {
  return NSUserInterfaceItemIdentifier(rawValue: input)
}
