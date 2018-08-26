//
//  CategoryTableViewCell.swift
//  TaskManager
//
//  Created by mac on 25.08.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class CategoryTableViewCell: UITableViewCell {

    lazy var categoryColourImgView: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2.0
        imageView.backgroundColor = UIColor(red: 210/255.5, green: 210/255.5, blue: 210/255.5, alpha: 1.0)
        return imageView
    }()
    lazy var categoryNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.textColor = UIColor.black
        
        return label
    }()
    
    func configureView() {
        contentView.addSubview(categoryColourImgView)
        contentView.addSubview(categoryNameLabel)
    }
    
    func configureConstraint() {
        let foobar = AppDelegate.foobar
        
        categoryColourImgView <- [
            CenterY(0),
            Left(foobar*0.064),
            Width(20),
            Height(20)
        ]
        categoryNameLabel <- [
            CenterY(0),
            Left(foobar*0.053).to(categoryColourImgView),
            Right(foobar*0.005)
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
