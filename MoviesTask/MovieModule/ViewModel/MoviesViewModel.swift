//
//  MoviesViewModel.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import Foundation

final class MoviesViewModel {
    
    var movies: [CMovie] = [CMovie]()
    lazy var pageNo: Int = 1
    lazy var isLoading: Bool = false
    var searchText: String = ""
    var neteorkManager: NetworkProtocol
    var dbManager:CoreDataProtocol
    init(networkManager:NetworkProtocol = NetworkManager(),
         coredata:CoreDataProtocol = CoreDataManager()) {
        neteorkManager = networkManager
        dbManager = coredata
    }
    func load(completion: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let mvs = self.dbManager.fetchMovies(string: searchText,min: (pageNo-1) * 20)
            if mvs.isEmpty {
                getMovies(completion: completion)
            } else {
                movies += self.dbManager.fetchMovies(string: "", min: (pageNo-1) * 20)
                isLoading = false
                pageNo += 1
                completion()
            }
        }
    }
    
    func search(completion: @escaping () -> Void) {
        pageNo = 1
        movies = []
        load(completion: completion)
    }

    func getMovies(completion: @escaping () -> Void) {
        let model = MovieRequestModel(page: pageNo)
        let urlRequest = MovieRequest(queryParams: model.asDictionary).asURLRequest()!
        
        neteorkManager.fetch(request: urlRequest) {  (result:Result<MovieResponseModel, NetworkRequestError>) in
            switch result {
            case .success(let resp):
                if let movies = resp.results {
                    self.dbManager.saveMovies(movies: movies) { [self] in
                        if self.isLoading {
                            sleep(2)
                            let cMovies: [CMovie] = self.dbManager.fetchMovies(string: "", min: (pageNo-1) * 20)
                            self.movies += cMovies
                            self.isLoading = false
                            self.pageNo += 1
                            completion()
                        }
                    }
                }
            case  .failure(_):
                self.movies += []
                self.isLoading = false
                completion()
            }
        }
    }
}

