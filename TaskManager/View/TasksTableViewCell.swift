//
//  TasksTableViewCell.swift
//  TaskManager
//
//  Created by mac on 23.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class TasksTableViewCell: UITableViewCell {

    lazy var taskLabel: UILabel = {
       var label = UILabel()
       label.font = UIFont(name: "Avenir", size: 14)
       label.textColor = UIColor.black
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.numberOfLines = 0
       return label
    }()
    
    lazy var deadlineLabel: UILabel = {
       var label = UILabel()
       label.font = UIFont(name: "Avenir", size: 10)
       label.textColor = UIColor.black
       return label
    }()
    
    lazy var categoryImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2.0
        imageView.backgroundColor = UIColor(red: 210/255.5, green: 210/255.5, blue: 210/255.5, alpha: 1.0)
       return imageView
    }()
    
    func configureView() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(categoryImageView)
    }
    
    func configureConstraint() {
        let foobar = AppDelegate.foobar
        
        categoryImageView <- [
            CenterY(0),
            Left(foobar*0.04),
            Width(20),
            Height(20)
        ]
        taskLabel <- [
            Top(foobar*0.013),
            Left(foobar*0.053).to(categoryImageView),
            Right(foobar*0.005)
        ]
        deadlineLabel <- [
            Left(foobar*0.053).to(categoryImageView),
            Right(foobar*0.005),
            Top(3).to(taskLabel),
            Bottom(foobar*0.013)
        ]
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
