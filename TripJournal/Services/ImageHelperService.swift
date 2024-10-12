//
//  ImageHelperService.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-04.
//

import Foundation
import SwiftUI

struct ImageHelperService {
    
    static let shared = ImageHelperService()
    
    private init() {}
    
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
    
    /**
     Creates the URL object needed to access a photo item with the associated trip, day, content path.
     TripId must always be passed and associated dayId must be passed when attempting to create a URL for a content item.
     - Parameter tripId: Id for either the trip associated with the photo to be fetched, or the parent trip for the day or content item photo.
     - Parameter dayId: Id for either the day accociated with the photo to be fetched, or the parent day for the content item.
     - Parameter contentId: Id for the content item associated with the photo to be fetched.
     
     - Returns: URL needed to access Photo content from Documents directory for associated item.
     */
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
