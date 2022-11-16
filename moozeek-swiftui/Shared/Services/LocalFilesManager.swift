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
    static func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )
        return "file://" + documentDirectory[0]
    }
    
    private static func append(
        toPath path: String,
        withPathComponent pathComponent: String
    ) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        return nil
    }
    
    private static func read(fromDocumentsWithFileName fileName: String) {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            let savedString = try String(contentsOfFile: filePath)
            
            print(savedString)
        } catch {
            print("Error reading saved file")
        }
    }
    
    private static func save(
        data: Data,
        toDirectory directory: String,
        withFileName fileName: String
    ) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            try data.write(to: URL(string: filePath)!)
        } catch {
            print("Error", error)
            return
        }
        print("Save successful")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getLocalFileURL(withNameAndExtension fileName_ext: String) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName_ext)
    }
    
    static func getLocalFileSize(fileName_ext: String) -> String {
        do {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let dataPathStr = documentsDirectory + "/\(fileName_ext)"
            let attr = try FileManager.default.attributesOfItem(atPath: dataPathStr)
            let fileSize = attr[FileAttributeKey.size] as! UInt64
            return ByteCountFormatter().string(fromByteCount: Int64(bitPattern: fileSize))
        } catch {
            print("Error: \(error.localizedDescription)")
            return ""
        }
    }
    
    static func downloadFile(from link: URL, filename: String, extension ext: String, completion: ((Error?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: URLRequest(url: link)) { data, urlResponse, error in
            if let error {
                print("ERROR: \(error.localizedDescription)")
            }
            
            guard let data else { return }
            let fileName = filename + "." + ext
            self.save(data: data, toDirectory: documentDirectory(), withFileName: fileName)
            completion?(nil)
        }.resume()
    }
    
    static func extractDurationForSong(songID: String, songExtension: String) -> String {
        let asset = AVAsset(url: LocalFilesManager.getLocalFileURL(withNameAndExtension: "\(songID).\(songExtension)"))
        return TimeInterval(CMTimeGetSeconds(asset.duration)).stringFromTimeInterval()
    }
    
    static func deleteFile(withNameAndExtension filename_ext: String) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let dataPathStr = documentsDirectory + "/" + filename_ext
        if FileManager.default.fileExists(atPath: dataPathStr) {
            do {
                try FileManager.default.removeItem(atPath: dataPathStr)
                print("Removed file: \(dataPathStr)")
            } catch let removeError {
                print("couldn't remove file at path", removeError.localizedDescription)
                return false
            }
        }
        return true
    }
}
