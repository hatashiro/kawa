import Cocoa

class ShortcutViewController: NSViewController {
    @IBOutlet weak var tableView: ShortcutTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInputSources()
    }

    func loadInputSources() {
        tableView.dataSource = tableView
        tableView.delegate = tableView
        tableView.reloadData()
    }
}
