//
//  CoreDataManager.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataProtocol {
    func saveMovies(movies: [Movie], completion: @escaping () -> Void)
    func saveMovie(movie: Movie, completion: @escaping () -> Void)
    func fetchMovies(string: String, min: Int) -> [CMovie]
}

class CoreDataManager: CoreDataProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request: NSFetchRequest<CMovie> = CMovie.fetchRequest()
    
    func saveMovies(movies: [Movie], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        movies.forEach { movie in
            dispatchGroup.enter()
            self.saveMovie(movie: movie) {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func saveMovie(movie: Movie, completion: @escaping () -> Void) {
        let newMovie = CMovie(context: context)
        movie.posterURL.getImage { [self] data in
            newMovie.id = Int64(movie.id)
            newMovie.title = movie.title
            newMovie.overview = movie.overview
            newMovie.release_date = movie.release_date
            newMovie.posterImage = data
            completion()
            do {
                try context.save()
            } catch {
                
            }
        }
    }
    
    func fetchMovies(string: String , min: Int) -> [CMovie] {
        do {
            if !string.isEmpty {
                request.predicate = NSPredicate(format: "title CONTAINS[c] %@", string)
            }
            request.fetchOffset = min;
            request.fetchLimit = 20;
            return try context.fetch(request)
        } catch {}
        return []
    }
}
