//
//  RepositoryListViewModel.swift
//  GitHubMVVM
//
//  Created by Nadiia Pavliuk on 2/27/18.
//  Copyright © 2018 Nadiia Pavliuk. All rights reserved.
//

import Foundation


struct RepositoryListCellViewModel {
    let titleText: String
    let descText: String
    let starAndForkText: String
}

struct DescriptionViewModel {
    let name: String
    let description: String
    let url: String
    let forks: String
    let stars: String
    let language: String
    let created: String
    let updated: String
    let pushed: String
}


class RepositoryListViewModel {
    
    let apiService: APIServiceProtocol
    
    private var repositories: [Repository] = [Repository]()
    
    private var cellViewModels: [RepositoryListCellViewModel] = [RepositoryListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    //    private var dViewModels: [DescriptionViewModel] = [DescriptionViewModel]() {
    //        didSet {
    //            self.reloadTableViewClosure?()
    //        }
    //    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    var selectedRepository: Repository?
    var updateLoadingStatus: (()->())?
    var reloadTableViewClosure: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchAllRepositories { [weak self] (success, repositories, error) in
            self?.isLoading = false
            self?.processFetchedRepository(repositories: repositories)
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> RepositoryListCellViewModel {
        return cellViewModels[indexPath.row]
        
    }
    
    func createCellViewModel( repository: Repository ) -> RepositoryListCellViewModel {
        return RepositoryListCellViewModel( titleText: repository.name,
                                            descText: repository.description ?? "",
                                            starAndForkText: "Star: " + String(repository.forks) + " " + "Fork: " + String(repository.watchers)
        )
    }
    //    func openDescriptionViewModel( repository: Repository ) -> DescriptionViewModel {
    //        return DescriptionViewModel(name: repository.name, description: repository.description ?? "", //////////)
    //    }
    
    private func processFetchedRepository( repositories: [Repository] ) {
        self.repositories = repositories // Cache
        var vms = [RepositoryListCellViewModel]()
        //var vmDESCs = [DescriptionViewModel]()
        
        for repository in repositories {
            //vmDESCs.append(openDescriptionViewModel(repository: repository))
            vms.append( createCellViewModel(repository: repository) )
        }
        self.cellViewModels = vms
        
    }
}

extension RepositoryListViewModel {
    //    var reloadDescriptionViewClosure: (()->())?
    //    private var descriptViewModels: [DescriptionViewModel] = [DescriptionViewModel]() {
    //        didSet {
    //            self.reloadDescriptionViewClosure?()
    //        }
    //    }
    
    func userPressed( at indexPath: IndexPath ) {
        let repository = self.repositories[indexPath.row]
        self.isAllowSegue = true
        self.selectedRepository = repository
        
    }
}




