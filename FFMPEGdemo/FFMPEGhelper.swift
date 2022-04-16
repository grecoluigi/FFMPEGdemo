//
//  FFMPEGhelper.swift
//  FFMPEGdemo
//
//  Created by InTouch on 15/04/22.
//

import Foundation

class FFMPEGhelper {
    
    static let shared = FFMPEGhelper()
    private var arguments = [String]()

    func addArgument(argument: String) {
        arguments.append(argument)
    }
    
    func hasArgments() -> Bool {
        return !arguments.isEmpty
    }
    
    func numberOfArguments() -> Int {
        return arguments.count
    }
    
    func getArguments() -> String {
        var argumentString = ""
        for argument in arguments {
            argumentString.append("\(argument) ")
        }
        return argumentString
    }
    
    func removeLastArgument() -> Bool {
        guard hasArgments() else {
            return false
        }
        arguments.removeLast()
        return true
    }
    
    func createTempFileURL() -> URL {
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,                                        FileManager.SearchPathDomainMask.userDomainMask, true).last
            let pathURL = NSURL.fileURL(withPath: path!)
            let fileURL = pathURL.appendingPathComponent("vid-\(NSDate.timeIntervalSinceReferenceDate).mov")
            return fileURL
        }
    
    func runFFMPEG(inputFilePath: String, outputFilePath: String,
                      filterPath: String, callback: @escaping (Bool) -> Void) -> (Process, DispatchWorkItem)? {
        guard let launchPath = Bundle.main.path(forResource: "ffmpeg", ofType: "") else {
            return nil
        }
        let process = Process()
        let task = DispatchWorkItem {
            process.launchPath = launchPath
            process.arguments = [
                "-i", inputFilePath
            ]
            for argument in self.arguments {
                process.arguments?.append(argument)
            }
            process.arguments?.append(outputFilePath)
            process.standardInput = FileHandle.nullDevice
            process.launch()
            process.terminationHandler = { process in
                callback(process.terminationStatus == 0)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: task)
        
        return (process, task)
    }
}
