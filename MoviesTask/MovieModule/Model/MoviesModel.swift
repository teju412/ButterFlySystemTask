//
//  MoviesModel.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import Foundation

// RequestModel
struct MovieRequestModel: Encodable {
    var api_key: String = Constants.API_KEY
    var page: Int
}


// ResponseModel
struct MovieResponseModel: Codable {
    let page: Int?
    let results: [Movie]?
    let total_pages: Int?
    let total_results: Int?
}

struct Movie: Codable {
    let id: Int
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path ?? "")")!
    }
}



// Request

struct MovieRequest: Request {
    typealias ResponseType = MovieResponseModel
    var path: String = APPURL.MOVIE_API
    var method: HTTPMethod = .get
    var queryParams: Parameters?
    
    init(queryParams: Parameters) {
        self.queryParams = queryParams
    }
    
}
