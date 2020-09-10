//
//  ApiTests.swift
//  EvaluatonTestIosTests
//
//  Created by Константин Сабицкий on 09.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import XCTest
import UIKit
@testable import EvaluatonTestIos

class ApiTests: XCTestCase {
    
    var mockUrlSession: MockUrlSession!
    var sut: NetworkManager!

    override func setUp() {
        mockUrlSession = MockUrlSession(data: nil, urlResp: nil, err: nil)
        sut = NetworkManager()
        sut.urlSession = mockUrlSession
    }
    
    func getData() {
        let completion = { (returning: [SearchItem]) in }
        sut.getData(by: "Foo", entity: nil, page: 0, limit: 10, completion: completion)
    }
    
    func testManagerUsesCorrectHost() {
        getData()
        XCTAssertEqual(mockUrlSession.urlComponents?.host, "itunes.apple.com")
    }
    
    func testManagerUsesCorrectPath() {
        getData()
        XCTAssertEqual(mockUrlSession.urlComponents?.path, "/search")
    }
    
    func testManagerUsesExpectedQueryParams() {
        getData()
        guard let queryItems = mockUrlSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        let urlQueryTermName = URLQueryItem(name: "term", value: "Foo")
        XCTAssertTrue(queryItems.contains(urlQueryTermName))
    }
        
        
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}

extension ApiTests {
    
    class MockUrlSession: URLSessionProtocol {
        private let mockDataTask: MockDataTask
        
        var url: URL?
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
       
        init(data: Data?, urlResp: URLResponse?, err: Error?) {
            mockDataTask = MockDataTask(data: data, response: urlResp, err: err)
        }
        
        
        func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url.url
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
        
    }
    
    class MockDataTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let respError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, response: URLResponse?, err: Error?) {
            self.data = data
            self.urlResponse = response
            self.respError = err
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.respError)
            }
        }
        
    }
}

