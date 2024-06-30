//
//  NetworkServiceTests.swift
//  UnitiTunesTests
//
//  Created by Виктор on 03.06.2024.
//

import XCTest
@testable import iTunesTest

final class NetworkServiceTests: XCTestCase {

    var service: ITunesSearchNetworkServiceProtocol! = ITunesSearchNetworkService()
    
    override class func setUp() {
        super.setUp()
        
        
    }

    
    override class func tearDown() {
        
        super.tearDown()
    }
    
    func test() {
        let searchText = "Deep"
        
        service.searchMusicResultCompletion(with: searchText) { result in
//            XCTA/sse
//            XCTAssertEqual(result, .success(let _)
            switch result {
            case .success(let _):
                return
            case .failure(let error):
                XCTFail("Failure \(error)")
                return
            }
        }
//
//        let testExpectation = expectation(description: "Expected login completion handler to be called")
//        expectation.fulfill()
        
//        waitForExpectations(timeout: 1, handler: nil)
        
        // test Publisher
//        XCTAssertNoThrow(try awaitPublisher(service.searchMusicPublisher(with: searchText)))
    }
}

import Combine

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
