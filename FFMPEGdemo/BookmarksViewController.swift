//
//  BookmarksViewController.swift
//  FFMPEGdemo
//
//  Created by InTouch on 15/04/22.
//

import Foundation
import Cocoa

protocol BookmarksViewControllerDelegate {
    func didTapUseSelectedBookmark()
}

class BookmarksViewController : NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    var delegate : BookmarksViewControllerDelegate?
    let ffmpeg = FFMPEGhelper.shared
    var savedBookmarks = [String]()
    let defaults = UserDefaults.standard
    @IBOutlet weak var addBookmarkTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        savedBookmarks = defaults.object(forKey: "SavedBookmarks") as? [String] ?? [String]()
        tableView.reloadData()
    }
    
    override func viewWillDisappear() {
        defaults.set(savedBookmarks, forKey: "SavedBookmarks")
    }
    
    @IBAction func addBookmarkButtonPressed(_ sender: NSButton) {
        guard !addBookmarkTextField.stringValue.isEmpty else { return }
        savedBookmarks.append(addBookmarkTextField.stringValue)
        addBookmarkTextField.stringValue = ""
        tableView.reloadData()
    }
    
    @IBAction func deleteSelectedButtonPressed(_ sender: NSButton) {
        guard tableView.numberOfRows >= 1 else { return }
        savedBookmarks.remove(at: tableView.selectedRow)
        tableView.reloadData()
    }

    @IBAction func useSelectedButtonPressed(_ sender: NSButton) {
        let argumentsArray = savedBookmarks[tableView.selectedRow].components(separatedBy: " ")
        for argument in argumentsArray {
            ffmpeg.addArgument(argument: argument)
        }
        delegate?.didTapUseSelectedBookmark()
        dismiss(self)
    }
}

extension BookmarksViewController: NSTableViewDataSource {
   func numberOfRows(in tableView: NSTableView) -> Int {
       return savedBookmarks.count
   }
}

extension BookmarksViewController: NSTableViewDelegate {
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "bookmarkCell")
      guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
      cellView.textField?.stringValue = savedBookmarks[row]
      return cellView
   }
}
