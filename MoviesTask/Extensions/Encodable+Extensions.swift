//
//  Encodable+Extensions.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//


import Foundation

extension Encodable {
    var asDictionary: [String: Any] {
        guard
            let data = try? JSONEncoder().encode(self)
        else { return [:] }
        
        guard
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }
}
