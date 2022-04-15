//
//  ImageManager.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation
import FirebaseStorage
import UIKit

class ImageManager {
    
    static var shared: ImageManager = ImageManager()
    
    private let storageReference = Storage.storage().reference()
    
    private var imageCache: [String:Data] = [:]
    
    init() {}
    
    func uploadImage(imageData: [Data], completion: @escaping (_ imageURLs: [String?],
                                                               _ imageNames: [String?]) -> Void) {
        var imageURLs = [String?](repeating: nil, count: imageData.count)
        var imageNames = [String?](repeating: nil, count: imageData.count)
        
        for i in 0..<imageData.count {
            
            let imageName = UUID().uuidString
            imageNames[i] = imageName
            
            print(imageData)
            let storageRef = storageReference.child("\(imageName).jpeg")
            storageRef.putData(imageData[i], metadata: nil) { (metadata, error)  in
                if let error = error {
                    print("error putData")
                    imageURLs = [String?](repeating: nil, count: imageData.count)
                    BookManager.shared.output?.didFail(with: error)
                    return
                }
                else {
                    storageRef.downloadURL { (url, error) in
                        if url == nil {
                            return
                        }
                        imageNames[i] = imageName
                        imageURLs[i] = url?.absoluteString
                        if !imageURLs.contains(nil) {
                            completion(imageURLs, imageNames)
                        }
                    }
                }
            }
        }
        
    }
    
    
    func getImage(with name: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let name = "\(name).jpeg"
        
        if let data = imageCache[name] {
            completion(.success(data))
            return
        }
        
        storageReference.child(name).getData(maxSize: 15 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                self?.imageCache[name] = data
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.unexpected))
            }
        }
    }
    
    func deleteImages(imageNames : [String]) -> Bool {
        
        var count = 0
        
        for name in imageNames {
            storageReference.child("\(name).jpeg").delete { error in
                if let error = error {
                    BookManager.shared.output?.didFail(with: error)
                    print("error in deleting images\(error)")
                }
                else {
                    count += 1
                    print(count, "image deleted")
                }
            }
        }
        return true
    }
}
