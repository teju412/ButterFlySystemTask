//
//  MoviesTaskTests.swift
//  MoviesTaskTests
//
//  Created by TejaDanasvi on 18/10/2023.
//

import XCTest
@testable import MoviesTask
import CoreData

final class MoviesTaskTests: XCTestCase {
    func testIsReturnSuccessResultFromNetwork() {
        let model = MockMovie()
        model.title = "title"
        let mockDBData = [model]
        
        let stub = createMockData(mockData: createMoviewModel(), errorCode: 0, isFailure: false, dbData: mockDBData)
        
        let expectation = expectation(description: "test")
        
        stub.load {
            expectation.fulfill()
        }
        wait(for: [expectation],timeout: 0.8)
        
        XCTAssertNotNil(stub.movies)
        XCTAssertEqual(stub.movies.count, 1)
    }
    
    func testIsReturnFailureResultFromNetwork() {
                
        let stub = createMockData(mockData: createMoviewModel(), errorCode: 500, isFailure: true, dbData: [])
        
        let expectation = expectation(description: "test")
        
        stub.load {
            expectation.fulfill()
        }
        wait(for: [expectation],timeout: 0.8)
       
        XCTAssertEqual(stub.movies.count, 0)
    }
    
    func testSerchDataReturnSuccessData() {
        let model = MockMovie()
        model.title = "title"
        let mockDBData = [model]
        
        let stub = createMockData(mockData: createMoviewModel(), errorCode: 0, isFailure: false, dbData: mockDBData)
        
        let expectation = expectation(description: "test")
        
        stub.search(completion: {
            expectation.fulfill()
        })
        
        wait(for: [expectation],timeout: 0.8)
        
        XCTAssertNotNil(stub.movies)
        XCTAssertEqual(stub.movies.count, 1)
    }
    
    
    func createMoviewModel() -> MovieResponseModel {
        let movies = Movie(id: 2, adult: true, backdrop_path: "", genre_ids: [1,2], original_language: "english", original_title: "test", overview: "test", popularity: nil, poster_path: nil, release_date: nil, title: "title", video: false, vote_average: nil, vote_count: nil)
        
        let model = MovieResponseModel(page: 1, results: [movies], total_pages: 1, total_results: 1)
        return model
    }
    
    func createMockData(mockData:MovieResponseModel,
                       errorCode: Int,
                        isFailure:Bool,
                        dbData:[MockMovie]) -> MoviesViewModel {
        
        
        let mockNetwork = MockNetworkManager(successResult: mockData, errorCode: errorCode,isFailure: isFailure)
        
        let mockDb = MockCoreDataManager(result:dbData)
        
        let viewModel = MoviesViewModel(networkManager: mockNetwork,coredata: mockDb)
        
        return viewModel
        
    }
}

class MockMovie : CMovie {
    
    init() {
        super.init(entity: CMovie.entity(), insertInto: nil)
    }
}
