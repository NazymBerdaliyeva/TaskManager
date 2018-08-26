//
//  AddViewController.swift
//  TaskManager
//
//  Created by mac on 24.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class AddViewController: UIViewController, PizzaDelegate {

    lazy var taskNameLabel: UILabel = {
        var label = UILabel()
        label.text = "The Task"
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var deadlineLabel: UILabel = {
        var label = UILabel()
        label.text = "Deadline"
        label.font = UIFont(name: "Avenir-Light", size: 18)
        return label
    }()
    
    lazy var categoryLabel: UILabel = {
        var label = UILabel()
        label.text = "Category"
        label.font = UIFont(name: "Avenir-Light", size: 18)
        return label
    }()
    
    lazy var taskTextField: UITextField = {
        var textfield = UITextField()
        textfield.layer.masksToBounds = true
        textfield.autocorrectionType = .no
        textfield.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingChanged)
        return textfield
    }()
    
    lazy var deadlineTextField: UITextField = {
        var textfield = UITextField()
        textfield.layer.masksToBounds = true
        textfield.addTarget(self, action: #selector(deadlineTextFieldEditing(_:)), for: UIControlEvents.editingDidBegin)
        return textfield
    }()
    
    lazy var chooseCategoryButton: UIButton = {
        var button = UIButton()
//        button.setTitle("General", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        button.sizeToFit()
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    lazy var categoryImgView: UIImageView = {
        var imgView = UIImageView(frame: CGRect(x:0, y: 0, width: 20, height: 20))
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        imgView.backgroundColor = UIColor(red: 210/255.5, green: 210/255.5, blue: 210/255.5, alpha: 1.0)
        return imgView
    }()
    
    lazy var categoryNameLabel: UILabel = {
        var label = UILabel()
        label.text = "General"
        label.tintColor = UIColor.lightGray
        label.font = UIFont(name: "Avenir-Light", size: 18)
        return label
    }()
    
    @objc func deadlineTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func selectCategory() {
        let vc = CategoryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func configurView() {
        [taskNameLabel, deadlineLabel, categoryLabel, taskTextField, deadlineTextField, chooseCategoryButton].forEach{
            self.view.addSubview($0)
        }
        self.chooseCategoryButton.addSubview(categoryImgView)
        self.chooseCategoryButton.addSubview(categoryNameLabel)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.5686, green: 0.6902, blue: 0.9882, alpha: 1.0)
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(tappedButton))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let backImage = UIImage(named: "close")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    func configureConstraints() {
        let foobar = AppDelegate.foobar
        
        taskNameLabel <- [
            Top(foobar*0.267),
            Left(foobar*0.04),
            Width(foobar*0.88)
        ]
        taskTextField <- [
            Top(foobar*0.093).to(taskNameLabel),
            Left(foobar*0.04),
            Width(foobar*0.88)
        ]
        deadlineLabel <- [
            Top(foobar*0.093).to(taskTextField),
            Left(foobar*0.04),
            Width(foobar*0.88)
        ]
        deadlineTextField <- [
            Top(foobar*0.093).to(deadlineLabel),
            Left(foobar*0.04),
            Width(foobar*0.88)
        ]
        categoryLabel <- [
            Top(foobar*0.093).to(deadlineTextField),
            Left(foobar*0.04),
            Width(foobar*0.88)
        ]
        chooseCategoryButton <- [
            Top(foobar*0.04).to(categoryLabel),
            Left(foobar*0.0267),
            Width(foobar*0.88),
            Height(foobar*0.117)
        ]
        
        categoryImgView <- [
            CenterY(0),
            Width(20),
            Height(20),
            Left(foobar*0.02)
        ]
        categoryNameLabel <- [
            CenterY(),
            Left(foobar*0.04).to(categoryImgView)
        ]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configurView()
        configureConstraints()
    }

    override func viewDidLayoutSubviews() {
        addBottomBorderLine(taskTextField)
        addBottomBorderLine(deadlineTextField)
    }
   
    func onPizzaReady(type: String)
    {
        
        print("Pizza ready. The best pizza of all pizzas is... \(type)")
        self.categoryNameLabel.text = type
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        deadlineTextField.text = dateFormatter.string(from: sender.date)
        
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(backgroundTap(gesture:)));
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func backgroundTap(gesture : UITapGestureRecognizer) {
        deadlineTextField.resignFirstResponder()
    }
    @objc func tappedButton() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let task = Task(context: context)
        
        task.text = taskTextField.text!
        task.deadline = deadlineTextField.text!
        task.categoryName = categoryNameLabel.text!
//        task.categoryColour = toString(categoryImgView.backgroundColor)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let nextVC = HomeController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func textFieldDidEndEditing() {
        if taskTextField.hasText {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    func addBottomBorderLine(_ textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }

}
