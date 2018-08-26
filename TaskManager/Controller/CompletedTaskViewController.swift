//
//  CompletedTaskViewController.swift
//  TaskManager
//
//  Created by mac on 26.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import EasyPeasy
import CoreData

class CompletedTaskViewController: UIViewController {

    var completedToDoTasks: [CompletedTask] = []
    
    lazy var completedTaskTableView: UITableView = {
        var view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor.white
        view.rowHeight = 44
        view.separatorStyle = .none
        view.register(TasksTableViewCell.self, forCellReuseIdentifier: "completedTaskCell")
        return view
    }()
    func configureView() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(completedTaskTableView)
        
        let backImage = UIImage(named: "close")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    func configureConstraints() {
        completedTaskTableView <- Edges(0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraints()
        fetchCompletedTasks()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    func fetchCompletedTasks() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = delegate.persistentContainer.viewContext
        
        do {
            completedToDoTasks = try context.fetch(CompletedTask.fetchRequest())
            completedTaskTableView.reloadData()
        } catch {
            print("Fetching failed")
        }
    }
}
extension CompletedTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 500
    }
}
extension CompletedTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedToDoTasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "completedTaskCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as? TasksTableViewCell
        let completed = completedToDoTasks[indexPath.row]
        //let colour = completed.categoryColour
        cell?.taskLabel.text = completed.text
        cell?.deadlineLabel.text = completed.deadline
     //   cell?.categoryImageView.backgroundColor = UIColor(hexString: colour!)
        return cell!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let task = completedToDoTasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                completedToDoTasks = try context.fetch(CompletedTask.fetchRequest())
            } catch {
                print("Fetching failed")
            }
        }
        
        completedTaskTableView.reloadData()
    }
}
