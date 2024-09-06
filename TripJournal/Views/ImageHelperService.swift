//
//  Trip+coverImage.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-04.
//

import Foundation
import SwiftUI

struct ImageHelperService {
    
    static let shared = ImageHelperService()
    
    private init() {}
    
    func fileName(for trip: Trip) -> String {
        return "\(trip.id).png"
    }
    
    func fileName(for day: Day) -> String {
        return "\(day.id).png"
    }
    
    func imageURL(for trip: Trip) -> URL {
        return directoryURLFor(trip: trip).appending(path: fileName(for: trip))
    }
    
    func imageURL(for day: Day) -> URL {
        return directoryURLFor(day: day).appending(path: fileName(for: day))
    }
    
    func directoryURLFor(trip: Trip) -> URL {
        URL.documentsDirectory.appending(path: trip.id)
    }
    
    func directoryURLFor(day: Day) -> URL {
        return directoryURLFor(trip: day.trip).appending(path: day.id)
    }
    
    func saveImage(data: Data, for day: Day) {
        saveImage(data: data, directory: directoryURLFor(day: day), fileName: fileName(for: day))
    }
    
    func saveImage(data: Data, for trip: Trip) {
        print("ImageHelper: saving data for trip")
        saveImage(data: data, directory: directoryURLFor(trip: trip), fileName: fileName(for: trip))
    }
    
    private func saveImage(data: Data, directory: URL, fileName: String) {
        print("ImageHelper: saving image data")
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            
            let saveFileURL = directory.appending(path: fileName)
            
            try data.write(to: saveFileURL, options: [.atomic, .completeFileProtection])
            
            print("Saving Image at \(saveFileURL)")
        } catch {
            print("Error Saving: \(error.localizedDescription)")
        }
    }
    
    func imageDataFor(trip: Trip) -> Data? {
        imageDataFor(fileURL: directoryURLFor(trip: trip).appending(path: fileName(for: trip)))
    }
    
    func imageDataFor(day: Day) -> Data? {
        imageDataFor(fileURL: directoryURLFor(day: day).appending(path: fileName(for: day)))
    }
    
    func imageDataFor(fileURL: URL) -> Data? {
        
        print("loading Image data")

            
        if FileManager.default.fileExists(atPath: fileURL.relativePath) {
            do {
                print("Loading data at path \(fileURL)")
                return try Data(contentsOf: fileURL)
            } catch {
                print("Failed to load image, encountered errors: \(error.self)\(error.localizedDescription)")
            }
        } else {
            print("Could not find image at path \(fileURL)")
        }
        return nil
    }
}
