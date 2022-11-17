//
//  LocalFilesManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import XCDYouTubeKit

class LocalFilesManager {
    
    // MARK: - Properties
    
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
    
    // MARK: - Public methods
    
    func downloadFile(from url: URL, filename: String, extension ext: String, completion: ((Error?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, urlResponse, error in
            if let error {
                self?.log("Error: \(error.localizedDescription)")
                return
            }
            guard let data else { return }
            let fileName = filename + "." + ext
            self?.save(data: data, toDirectory: Self.documentDirectoryPath, withFileName: fileName)
            completion?(nil)
        }.resume()
    }
    
    func getUrlsForFiles(withExtension ext: String) -> [URL] {
        do {
            let path = Self.documentDirectoryUrl.absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: path,
                includingPropertiesForKeys: nil,
                options: []
            )
            return directoryContents.filter { $0.lastPathComponent.split(separator: ".").last! == ext }
        } catch {
            log("Error: \(error)") // TODO: JR
            return []
        }
    }
    
    @discardableResult
    func deleteFile(withNameAndExtension fileName: String) -> Bool {
        let dataPathStr = Self.documentDirectoryPath + "/" + fileName
        guard FileManager.default.fileExists(atPath: dataPathStr) else { return true }
        do {
            try FileManager.default.removeItem(atPath: dataPathStr)
            log("Removed file: \(dataPathStr)")
        } catch let removeError {
            log("Couldn't remove file at path: \(removeError.localizedDescription)")
            return false
        }
        return true
    }
    
    // MARK: - Internal implementation
    
    private func save(data: Data, toDirectory directory: String, withFileName fileName: String) {
        let filePath = Self.documentDirectoryUrl.appendingPathComponent(fileName).absoluteString
        do {
            try data.write(to: URL(string: filePath)!)
            log("Save successful")
        } catch {
            log("Error: \(error)")
        }
    }
    
    private func log(_ message: String) {
        guard Self.loggingEnabled else { return }
        print("LocalFilesManager: ", message)
    }
}
