//
//  ApiService.swift
//  GitHubMVVM
//
//  Created by Nadiia Pavliuk on 2/27/18.
//  Copyright © 2018 Nadiia Pavliuk. All rights reserved.
//

import Foundation


protocol APIServiceProtocol {
    func fetchAllRepositories( complete: @escaping ( _ success: Bool, _ repositories: [Repository], _ error: Error? )->() )
}

class APIService: APIServiceProtocol {

    func fetchAllRepositories( complete: @escaping ( _ success: Bool, _ repositories: [Repository], _ error: Error? )->() ) {

        let url = URL(string: "https://api.github.com/users/cocoapods/repos?page=1&per_page=100;%20rel=next")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    var repositories: [Repository]
                    repositories = try JSONDecoder().decode([Repository].self, from: data!)
                    DispatchQueue.main.async {
                        complete(true,repositories, nil)
                    }
                } catch {
                    print("Error \(error)")
                }
            }
            }.resume()

    }
}

