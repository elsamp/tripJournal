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
    
    func fileName(for content: ContentItem) -> String {
        return "\(content.id).png"
    }
    
    func imageURL(for trip: Trip) -> URL {
        return directoryURLFor(trip: trip).appending(path: fileName(for: trip))
    }
    
    func imageURL(for day: Day) -> URL {
        return directoryURLFor(day: day).appending(path: fileName(for: day))
    }
    
    func imageURL(for content: ContentItem) -> URL {
        return directoryURLFor(day: content.day).appending(path: fileName(for: content))
    }
    
    func directoryURLFor(trip: Trip) -> URL {
        URL.documentsDirectory.appending(path: trip.id)
    }
    
    func directoryURLFor(day: Day) -> URL {
        return directoryURLFor(trip: day.trip).appending(path: day.id)
    }
    
    func directoryURLFor(content: ContentItem) -> URL {
        return directoryURLFor(day: content.day)
    }
    
    func saveImage(data: Data, for day: Day) {
        saveImage(data: data, directory: directoryURLFor(day: day), fileName: fileName(for: day))
    }
    
    func saveImage(data: Data, for trip: Trip) {
        print("ImageHelper: saving data for trip")
        saveImage(data: data, directory: directoryURLFor(trip: trip), fileName: fileName(for: trip))
    }
    
    func saveImage(data: Data, for content: ContentItem) {
        print("ImageHelper: saving data for content")
        saveImage(data: data, directory: directoryURLFor(content: content), fileName: fileName(for: content))
    }
    
    func imageDataFor(trip: Trip) -> Data? {
        imageDataFor(fileURL: directoryURLFor(trip: trip).appending(path: fileName(for: trip)))
    }
    
    func imageDataFor(day: Day) -> Data? {
        imageDataFor(fileURL: directoryURLFor(day: day).appending(path: fileName(for: day)))
    }
    
    func imageDataFor(content: ContentItem) -> Data? {
        imageDataFor(fileURL: directoryURLFor(day: content.day).appending(path: fileName(for: content)))
    }
    
    
    //MARK: Keep
    /**
     Fetches image data for passed ids. Day id's must be provided when fetching content image data.
     - Parameter tripId: The id of the associated trip
     - Parameter dayId: The id of the associated day. Must provide a value if fetching a content image
     - Parameter contentId: The id of the associated content item. Day id must be passed when fetching content image data.
     
     - Returns: Image data for the passed ids if found.
     */
    func fetchImageDataFor(tripId: String, dayId: String? = nil, contentId: String? = nil) -> Data? {
        imageDataFor(fileURL: imageURLFor(tripId: tripId, dayId: dayId, contentId: contentId))
    }
    
    /**
     Saves passed image data in the documents directory. Sub directories are created for passed parent ids.
     - Parameter data: The image data to be saved
     - Parameter tripId: The id of the associated trip
     - Parameter dayId: The id of the associated day. Must provide a value if saving a content image
     - Parameter contentId: The id of the associated content entry. Day id must be passed when saving content image data.
     */
    func saveImageData(_ data: Data, tripId: String, dayId: String? = nil, contentId: String? = nil) {
        saveImage(data: data,
                  directory: directoryURLFor(tripId: tripId, dayId: dayId),
                  fileName: fileName(for: contentId ?? dayId ?? tripId))
    }
    
    func imageURLFor(tripId: String, dayId: String? = nil, contentId: String? = nil) -> URL {
        var imageURL: URL
        
        imageURL = URL.documentsDirectory.appending(path: tripId)
        
        if let dayId = dayId {
            
            imageURL.append(component: dayId)
            
            if let contentId = contentId {
                imageURL.append(component: fileName(for: contentId))
            } else {
                imageURL.append(component: fileName(for: dayId))
            }
        } else {
            imageURL.append(component: fileName(for: tripId))
        }
        
        print(imageURL)
        
        return imageURL
    }
    
    private func fileName(for id: String) -> String {
        return "\(id).png"
    }
    
    private func directoryURLFor(tripId: String, dayId: String? = nil) -> URL {
        var imageURL = URL.documentsDirectory.appending(path: tripId)
        
        if let dayId = dayId {
            imageURL.append(component: dayId)
        }
        
        return imageURL
    }
    
    private func imageDataFor(fileURL: URL) -> Data? {
        
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
}
