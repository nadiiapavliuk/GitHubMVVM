//
//  RepositoryListViewModelTest.swift
//  GitHubMVVMTests
//
//  Created by Nadiia Pavliuk on 2/27/18.
//  Copyright © 2018 Nadiia Pavliuk. All rights reserved.
//

import XCTest
@testable import GitHubMVVM

class RepositoryListViewModelTests: XCTestCase {
    
    var sut: RepositoryListViewModel!
    var mockAPIService: MockApiService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        sut = RepositoryListViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func test_fetch_repository() {
        // Given
        mockAPIService.completeRepositories = [Repository]()
        
        // When
        sut.initFetch()
        
        // Assert
        XCTAssert(mockAPIService!.isFetchAllRepositoryCalled)
    }
    
    
    func test_create_cell_view_model() {
        // Given
        let repositories = StubGenerator().stubRepositories()
        mockAPIService.completeRepositories = repositories
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        // When
        sut.initFetch()
        mockAPIService.fetchSuccess()
     
        XCTAssertEqual( sut.numberOfCells, repositories.count )
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
    }
    
    func test_loading_when_fetching() {
        
        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        sut.initFetch()
        
        // Assert
        XCTAssertTrue( loadingStatus )
        
        // When finished fetching
        mockAPIService!.fetchSuccess()
        XCTAssertFalse( loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_user_press() {
        
        //Given a sut with fetched repositories
        let indexPath = IndexPath(row: 0, section: 0)
        goToFetchRepositoryFinished()
        
        //When
        sut.userPressed( at: indexPath )
        
        //Assert
        XCTAssertTrue( sut.isAllowSegue )
        XCTAssertNotNil( sut.selectedRepository )
        
    }
  
    func test_get_cell_view_model() {
        
        //Given a sut with fetched repositories
        goToFetchRepositoryFinished()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testRepository = mockAPIService.completeRepositories[indexPath.row]
        
        // When
        let vm = sut.getCellViewModel(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.titleText, testRepository.name)
        
    }
    
    func test_cell_view_model() {
        
        let html_url = URL(string:"https://github.com/CocoaPods/blog.cocoapods.org")!
        
        let repository = Repository( name: "Name", description: "desc", forks: 0, watchers: 0, html_url: html_url, language: "Ruby", created_at: "457678", updated_at: "5678899", pushed_at: "54678")
        
        let repositoryWithoutDescription = Repository(name: "Name", description: nil, forks: 0, watchers: 0, html_url: html_url, language: "Ruby", created_at: "4567", updated_at: "5678899", pushed_at: "54678")
        
        // When creat cell view model
        let cellViewModel = sut!.createCellViewModel( repository: repository )
        let cellViewModelWithoutDesc = sut!.createCellViewModel( repository: repositoryWithoutDescription )
        
        
        // Assert the correctness of display information
        XCTAssertEqual(cellViewModel.titleText, repository.name)
        XCTAssertEqual(cellViewModel.descText, "\(repository.description!)" )
        XCTAssertEqual(cellViewModelWithoutDesc.descText, "")
        XCTAssertEqual(cellViewModel.starAndForkText,  "Star: \(repository.watchers)" + " " + "Fork: \(repository.forks)")
       
    }
    
}

//MARK: State control
extension RepositoryListViewModelTests {
    private func goToFetchRepositoryFinished() {
        mockAPIService.completeRepositories = StubGenerator().stubRepositories()
        sut.initFetch()
        mockAPIService.fetchSuccess()
    }
}


//MARK: MOCK
class MockApiService: APIServiceProtocol {
    
    var isFetchAllRepositoryCalled = false
    
    var completeRepositories: [Repository] = [Repository]()
    var completeClosure: ((Bool, [Repository], Error?) -> ())!
    
    func fetchAllRepositories(complete: @escaping (Bool, [Repository], Error?) -> ()) {
        isFetchAllRepositoryCalled = true
        completeClosure = complete
        
    }
    
    func fetchSuccess() {
        completeClosure( true, completeRepositories, nil )
    }
}

class StubGenerator {
    func stubRepositories() -> [Repository] {
        let url = URL(string: "https://api.github.com/users/cocoapods/repos?page=1&per_page=100;%20rel=next")
        let data = try! Data(contentsOf: url!)
        let repositories = try! JSONDecoder().decode([Repository].self, from: data)
        return repositories
    }
}

