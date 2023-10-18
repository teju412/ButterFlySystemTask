
//  UIImage+Extension.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import UIKit

extension URL {
    func getImage(completion: @escaping ((Data)->(Void))) {
        URLSession.shared.dataTask(with: self) { (data, response, error) in
            guard
                let _ = response,
                let imageData = data
            else { return }
            DispatchQueue.main.async {
                completion(imageData)
            }
        }.resume()
    }
}
