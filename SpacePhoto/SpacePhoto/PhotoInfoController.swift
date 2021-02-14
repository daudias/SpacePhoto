//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Dias on 2/14/21.
//

import Foundation
import UIKit

class PhotoInfoController {
    private let apiKey = "GFkCGo5I9dJS1HefrUXhXgqZNnpv3VZnZseasdfI"
    
    func fetchPhotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": apiKey
        ].map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
                    completion(.success(photoInfo))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    enum PhotoInfoError: Error, LocalizedError {
        case imageDataMissing
    }
    
    func fetchPhoto(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        let task = URLSession.shared.dataTask(with: urlComponents!.url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(PhotoInfoError.imageDataMissing))
            }
        }
        task.resume()
    }
}
