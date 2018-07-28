//
//  DragTableViewCell.swift
//  DragView
//
//  Created by Trương Văn Kiên on 6/14/18.
//  Copyright © 2018 Trương Văn Kiên. All rights reserved.
//

import UIKit

class DragTableViewCell: UITableViewCell {
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var describeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = UIColor.lightGray
        } else {
            self.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        }
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.clear
        
        childView.clipsToBounds = true;
        childView.layer.cornerRadius = 3.0
        
        holderView.layer.cornerRadius = 3.0
        holderView.layer.shadowColor = UIColor.gray.cgColor
        holderView.layer.shadowOffset = CGSize(width: 0, height: 0)
        holderView.layer.shadowOpacity = 0.5
        
        titleLabel.text = ""
        describeLabel.text = ""
    }
    
}
