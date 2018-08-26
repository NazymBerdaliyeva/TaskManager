//
//  CategoryViewController.swift
//  TaskManager
//
//  Created by mac on 25.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import EasyPeasy
import CoreData

protocol PizzaDelegate
{
    func onPizzaReady(type: String)
}

class CategoryViewController: UIViewController {

   
    
    var categoryList: [Category] = []
    var categoryValues: [NSManagedObject] = []
    
    var delegate:PizzaDelegate?
    
    
    
    var categoriesArray = [CategoryDetailStruct(name: "Sport", colour: "#ff0000"),
                           CategoryDetailStruct(name: "Health & Fitness", colour: "#ff8000"),
                           CategoryDetailStruct(name: "Business & Financial", colour: "#ffff00"),
                           CategoryDetailStruct(name: "Learning & Skills", colour: "#bfff00"),
                           CategoryDetailStruct(name: "Career", colour: "#00ffbf"),
                           CategoryDetailStruct(name: "New habits", colour: "#00ffff"),
                           CategoryDetailStruct(name: "Work", colour: "#0040ff"),
                               CategoryDetailStruct(name: "Social & Family", colour: "#8000ff"),
                               CategoryDetailStruct(name: "Personality", colour: "#ff00ff"),
                               CategoryDetailStruct(name: "Travel", colour: "#ff0080"),
                               CategoryDetailStruct(name: "Adventures", colour: "#0080ff")]
    
    lazy var categoryTableView: UITableView = {
        var view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor.white
        view.rowHeight = 44
        view.separatorStyle = .none
        view.register(CategoryTableViewCell.self, forCellReuseIdentifier: "categoryCell")
        return view
    }()
    func configureView() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to the task", style: .plain, target: self, action: #selector(addCategory))
        self.view.addSubview(categoryTableView)
    }
    func configureConstraints() {
//        let foobar = AppDelegate.foobar
        
        categoryTableView <- Edges(0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraints()
        deleteCategory()
        saveToCoreData()
        fetchCategory()
        
        var vc = AddViewController()
        self.delegate = vc
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    @objc func addCategory() {
        
        if (delegate != nil){
            let info = "Nazym"
            delegate!.onPizzaReady(type: info)
            self.navigationController?.popViewController(animated: true)
        } else {
            print("DELEGATE is nil")
        }
        
//        self.navigationController?.pushViewController(AddViewController(), animated: true)
    }
    
    func saveToCoreData() {
        for category in categoriesArray {
            let name = category.name
            let colour = category.colour
            self.saveToTheCategoryCoreData(name: name!, colour: colour!)
        }
    }
    
    func deleteCategory() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print ("Deleted")
        } catch {
            print ("There was an error")
        }
    }
    
    func saveToTheCategoryCoreData(name: String, colour: String) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = delegate.persistentContainer.viewContext
        let category = Category(context: context)
        category.name = name
        category.colour = colour
        
        do {
            try context.save()
            fetchCategory()
            print ("Saved")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchCategory() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = delegate.persistentContainer.viewContext
        
        do {
            categoryList = try context.fetch(Category.fetchRequest())
            categoryTableView.reloadData()
        } catch {
            print("Fetching failed")
        }
    }

}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 500
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "categoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as? CategoryTableViewCell
        let category = categoryList[indexPath.row]
        let colour = category.colour
        cell?.categoryNameLabel.text = category.name
        cell?.categoryColourImgView.backgroundColor = UIColor(hexString: colour!)
        return cell!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (delegate != nil){
            let info = categoryList[indexPath.row].name
            delegate!.onPizzaReady(type: info!)
            self.navigationController?.popViewController(animated: true)
        } else {
            print("delegate is nil")
        }
        
         let vc = AddViewController()
       vc.categoryNameLabel.text = categoryList[indexPath.row].name
//        self.dismiss(animated: true, completion: nil)
    //        vc.categoryImgView.backgroundColor = UIColor(hexString: categoryList[indexPath.row].colour!)
//        vc.categoryNameLabel.text = categoryList[indexPath.row].name
//        self.navigationController?.pushViewController(vc, animated: false)
        
    }
}
extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000FF) / 255
                    a = CGFloat(1.0)
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
