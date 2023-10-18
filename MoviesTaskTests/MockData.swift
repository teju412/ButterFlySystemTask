//
//  MockData.swift
//  MoviesTaskTests
//
//  Created by TejaDanasvi on 18/10/2023.
//

import Foundation
@testable import MoviesTask

struct MockNetworkManager<R:Codable>: NetworkProtocol {
    
    var successResult:R
    var errorCode:Int
    var isFailure:Bool = false
    
    func fetch<T:Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkRequestError>) -> Void) {
         
         if isFailure {
             completion(.failure(self.httpError(errorCode)))
         }else {
             completion(.success(successResult as! T))
         }
    }
    
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
     func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    /// Parses URLSession Publisher errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
      func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}


class MockCoreDataManager: CoreDataProtocol {
    
    var isSaved:Bool = false
    
    var result:[CMovie] = []
    init( result: [CMovie]) {
        self.result = result
    }
    
    func saveMovies(movies: [Movie], completion: @escaping () -> Void) {
        isSaved = true
        completion()
    }
    
    func saveMovie(movie: Movie, completion: @escaping () -> Void) {
        isSaved = true
        completion()
    }
    
    func fetchMovies(string: String , min: Int) -> [CMovie] {
        return result
    }
}


