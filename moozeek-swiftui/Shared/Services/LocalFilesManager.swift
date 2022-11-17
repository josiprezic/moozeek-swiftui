//
//  LocalFilesManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Foundation
import XCDYouTubeKit

// TODO: JR To be refactored

class LocalFilesManager {
    static var loggingEnabled = true
    
    static var documentDirectoryPath: String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )
        return "file://" + documentDirectory[0]
    }
    
    static var documentDirectoryUrl: URL {
        URL(string: documentDirectoryPath)!
    }
    
    private func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        return nil
    }
    
    private func save(data: Data, toDirectory directory: String, withFileName fileName: String) {
            guard let filePath = self.append(toPath: directory, withPathComponent: fileName) else { return }
            do {
                try data.write(to: URL(string: filePath)!)
                log("Save successful")
            } catch {
                log("Error: \(error)")
            }
        }
    
    private func getLocalFileURL(withNameAndExtension fileName: String) -> URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(fileName)
    }
    
    func downloadFile(from link: URL, filename: String, extension ext: String, completion: ((Error?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: URLRequest(url: link)) { [weak self] data, urlResponse, error in
            if let error {
                self?.log("ERROR: \(error.localizedDescription)")
            }
            
            guard let data else { return }
            let fileName = filename + "." + ext
            self?.save(data: data, toDirectory: Self.documentDirectoryPath, withFileName: fileName)
            completion?(nil)
        }.resume()
    }
    
    @discardableResult
    func deleteFile(withNameAndExtension fileName: String) -> Bool {
        let dataPathStr = Self.documentDirectoryPath + "/" + fileName
        if FileManager.default.fileExists(atPath: dataPathStr) {
            do {
                try FileManager.default.removeItem(atPath: dataPathStr)
                log("Removed file: \(dataPathStr)")
            } catch let removeError {
                log("Couldn't remove file at path: \(removeError.localizedDescription)")
                return false
            }
        }
        return true
    }
    
    private func log(_ message: String) {
        guard Self.loggingEnabled else { return }
        print(message)
    }
}
