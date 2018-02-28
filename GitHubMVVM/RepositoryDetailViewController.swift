//
//  RepositoryDetailViewController.swift
//  GitHubMVVM
//
//  Created by Nadiia Pavliuk on 2/27/18.
//  Copyright © 2018 Nadiia Pavliuk. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
    lazy var viewModel: RepositoryListViewModel = {
        return RepositoryListViewModel()
    }()
    
    var indexPath: IndexPath!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var pushedLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVM()
    }
    
    func initVM() {
        viewModel.initFetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

