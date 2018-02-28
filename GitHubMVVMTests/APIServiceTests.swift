//
//  GitHubMVVMTests.swift
//  GitHubMVVMTests
//
//  Created by Nadiia Pavliuk on 2/27/18.
//  Copyright © 2018 Nadiia Pavliuk. All rights reserved.
//

import XCTest
@testable import GitHubMVVM

class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetch_all_repositories() {
        
        // Given A apiservice
        let sut = self.sut!
        
        // When fetch all repositories
        let expect = XCTestExpectation(description: "callback")
        
        sut.fetchAllRepositories(complete: { (success, repositories, error) in
            expect.fulfill()
            XCTAssertEqual( repositories.count, 62)
            for repository in repositories {
                XCTAssertNotNil(repository.name)
            }
            
        })
        
        wait(for: [expect], timeout: 3.0)
    }
    
}

