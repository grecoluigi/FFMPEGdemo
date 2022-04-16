//
//  ViewController.swift
//  FFMPEGdemo
//
//  Created by Luigi Greco on 14/04/22.
//

import Cocoa

typealias ProcessMeta = (Process, DispatchWorkItem)
typealias ProgressCallback = (String) -> Void
typealias ProcessResult = ([String], [String], Int32)

class MainViewController: NSViewController {

    @IBOutlet weak var argumentsTextField: NSTextField!
    @IBOutlet var inputFileTextField: NSTextField!
    @IBOutlet weak var currentArgumentsTextField: NSTextField!
    var inputFilePath : String?
    var outputFilePath : String?
    let ffmpeg = FFMPEGhelper.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        inputFilePath = ""
        outputFilePath = ffmpeg.createTempFileURL().path
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.isOpaque = false
        view.window?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.8)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func openFileButtonPressed(_ sender: NSButton) {let dialog = NSOpenPanel();
        guard  ffmpeg.hasArgments() else {
            alert(message: "Add some arguments before selecting the input file", button: "OK")
            return
        }
        dialog.title                   = "Choose a file to open";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            if (result != nil) {
                let path: String = result!.path
                inputFilePath = path
                inputFileTextField.stringValue = path
                ffmpeg.runFFMPEG(inputFilePath: inputFilePath!, outputFilePath: outputFilePath!, filterPath: "") { result in
                    NSWorkspace.shared.selectFile(self.outputFilePath, inFileViewerRootedAtPath: "")
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func alert(message: String, button: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: button)
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    func updateArgumentsList() {
        currentArgumentsTextField.stringValue = "current arguments: -i inputFilePath \(ffmpeg.getArguments())"
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookmarksSegue" , let bookMarksViewController = segue.destinationController as? BookmarksViewController {
           bookMarksViewController.delegate = self
        }
    }

    @IBAction func addArgumentButtonPressed(_ sender: NSButton) {
        guard !argumentsTextField.stringValue.isEmpty else {
            return
        }

        ffmpeg.addArgument(argument: argumentsTextField.stringValue)
        argumentsTextField.stringValue = ""
        updateArgumentsList()
    }
    
    @IBAction func removeLastArgumentButtonPressed(_ sender: NSButton) {
        let result = ffmpeg.removeLastArgument()
        if result == false {
            alert(message: "No arguments to remove", button: "OK")
            return
        }
        updateArgumentsList()
    }
}

extension MainViewController: BookmarksViewControllerDelegate {
    func didTapUseSelectedBookmark() {
        updateArgumentsList()
    }
}
