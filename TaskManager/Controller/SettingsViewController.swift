//
//  SettingsViewController.swift
//  TaskManager
//
//  Created by mac on 25.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import EasyPeasy
import UserNotifications

class SettingsViewController: UIViewController {

    lazy var notificationLabel: UILabel = {
        var label = UILabel()
        label.text = "Enable notifications"
        label.font = UIFont(name: "Avenir-Light", size: 18)
        return label
    }()
    
    lazy var notificationSwitch: UISwitch = {
        var control = UISwitch(frame: CGRect(x: view.frame.width - 70, y: 82, width: 0, height: 0))
        control.isOn = true
        control.setOn(true, animated: false)
        
        control.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        return control
    }()
    
    lazy var newCategoryBtn: UIButton = {
        var button = UIButton()
        button.setTitle("Create a new category", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Light", size: 18)
        button.setTitleColor(.black, for: .normal)
        button.sizeToFit()
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
        return button
    }()
    @objc func switchValueDidChange(sender: UISwitch!) {
        if sender.isOn == true {
            print("on")
        } else {
            print("off")
        }
    }
    @objc func addNewCategory() {
        let vc = CreateNewCategoryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Settings"
        [notificationLabel, notificationSwitch, newCategoryBtn].forEach {
            self.view.addSubview($0)
        }
    }
    
    func cofigureConstraints() {
        let foobar = AppDelegate.foobar
        
        notificationLabel <- [
            Top(foobar*0.2267),
            Left(foobar*0.04),
            Width(foobar*0.88)
        ]
        newCategoryBtn <- [
             Top(foobar*0.1067).to(notificationLabel),
             Left(foobar*0.04),
             Width(foobar*0.88),
             Height(foobar*0.117)
        ]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        cofigureConstraints()
        // Do any additional setup after loading the view.
    }

    
}
