//
//  ViewController.swift
//  TaskManager
//
//  Created by mac on 23.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class HomeController: UIViewController {

    var toDoTasks: [Task] = []
    var completedToDoTasks: [CompletedTask] = []
    
    lazy var firstView: UIView = {
       var view = UIView()
       view.backgroundColor = UIColor.white
       return view
    }()
    lazy var toDosTableView: UITableView = {
        var view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor.white
        view.rowHeight = UITableViewAutomaticDimension
        view.register(TasksTableViewCell.self, forCellReuseIdentifier: "tasksCell")
        return view
    }()
    lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.text = "You don't have any tasks.\n\nAdd some tasks"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Black", size: 18)
        label.textColor = UIColor.black
        return label
    }()
    lazy var addTaskButton: UIButton = {
       var button = UIButton()
       button.setBackgroundImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addToDo), for: .touchUpInside)
       return button
    }()
    
    lazy var showComletedTasksButton: UIButton = {
        var button = UIButton()
        button.setTitle("Show Completed", for: .normal)
        button.addTarget(self, action: #selector(showCompletedToDo), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.sizeToFit()
        return button
    }()
    
    func configureViews() {
        self.view.addSubview(toDosTableView)
        self.view.addSubview(showComletedTasksButton)
        [statusLabel, addTaskButton].forEach {
            self.firstView.addSubview($0)
        }
        
        self.view.addSubview(firstView)
        self.navigationItem.title = "To Do"
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.5686, green: 0.6902, blue: 0.9882, alpha: 0.9)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(addToDo))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(goToSettingsVC))
        checkIfEmpty()
    }
    
    func configureConstraints() {
        let foobar = AppDelegate.foobar
        
        firstView <- Edges(0)
        
        toDosTableView <- Edges(0)
        
        showComletedTasksButton <- [
            CenterX(0),
            Bottom(foobar*0.05),
            Width(foobar*0.4),
            Height(foobar*0.192)
            ]
        statusLabel <- [
            CenterX(0),
            Top(foobar*0.293),
            Width(foobar*0.8)
        ]
        addTaskButton <- [
            CenterX(0),
            Top(foobar*0.213).to(statusLabel),
            Width(foobar*0.192),
            Height(foobar*0.192)
        ]
    }
  
    @objc func addToDo(){
        navigationItem.title = nil
        let vc = AddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToSettingsVC() {
        navigationItem.title = nil
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func showCompletedToDo() {
        let vc = CompletedTaskViewController()
        self.navigationController?.pushViewController(vc, animated: false)
        //present(vc, animated: false, completion: nil)
//        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let context = delegate.persistentContainer.viewContext
//
//        do {
//            //toDoTasks = try context.fetch(CompletedTask.fetchRequest()) as! [Task]
//            toDosTableView.reloadData()
//        } catch {
//            print("Fetching failed")
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "To Do"
        fetchData()
        toDosTableView.reloadData()
        checkIfEmpty()
    }
    
    func checkIfEmpty(){
        if self.toDoTasks.isEmpty{
            self.firstView.isHidden = false
            self.toDosTableView.isHidden = true
            navigationController?.navigationBar.isHidden = true
        }
        else {
            self.toDosTableView.isHidden = false
            self.firstView.isHidden = true
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    func fetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            toDoTasks = try context.fetch(Task.fetchRequest())
        } catch {
            print("Fetching failed")
        }
    }
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 500
    }
}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoTasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "tasksCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as? TasksTableViewCell
        let task = toDoTasks[indexPath.row]
        cell?.taskLabel.text = task.text!
        cell?.deadlineLabel.text = task.deadline
        //cell?.categoryImageView.backgroundColor = UIColor(hexString: task.categoryColour! as! String)
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
            let task = toDoTasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                toDoTasks = try context.fetch(Task.fetchRequest())
            } catch {
                print("Fetching failed")
            }
        }
        
        toDosTableView.reloadData()
        checkIfEmpty()
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            completion(true)
    }
        action.image = #imageLiteral(resourceName: "tick")
        action.backgroundColor = UIColor(red: 0.4784, green: 0.6510, blue: 0.1176, alpha: 1.0)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let completedtask = CompletedTask(context: context)
        completedtask.text = toDoTasks[indexPath.row].text
        completedtask.deadline = toDoTasks[indexPath.row].deadline
        context.delete(toDoTasks[indexPath.row])
        
        //completedtask.categoryColour = toDoTasks[indexPath.row].categoryColour
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        do {
            toDoTasks = try context.fetch(Task.fetchRequest())
        } catch {
            print("Fetching failed")
        }
        toDosTableView.reloadData()
        checkIfEmpty()
        return UISwipeActionsConfiguration(actions: [action])
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let label = toDoTasks[indexPath.row].text
//        
//    }
}

