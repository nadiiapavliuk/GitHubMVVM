//
//  RepositoriesModel.swift
//  GitHubMVVM
//
//  Created by Nadiia Pavliuk on 2/27/18.
//  Copyright © 2018 Nadiia Pavliuk. All rights reserved.
//

import Foundation
struct Repositories: Decodable {
    let repositories: [Repository]
}

struct Repository: Decodable {
    let name: String
    let description: String?
    let forks: Int
    let watchers: Int
    let html_url: URL!
    let language: String?
    let created_at: String?
    let updated_at: String?
    let pushed_at: String?
    
}

