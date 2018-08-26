//
//  CreateNewCategoryViewController.swift
//  TaskManager
//
//  Created by mac on 26.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class CreateNewCategoryViewController: UIViewController {

    func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(tappedButton))

    }
    @objc func tappedButton() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        // Do any additional setup after loading the view.
    }

   
}
