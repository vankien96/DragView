//
//  PageTabCell.swift
//  DragView
//
//  Created by Trương Văn Kiên on 6/14/18.
//  Copyright © 2018 Trương Văn Kiên. All rights reserved.
//

import UIKit

class PageTabCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    var tabName: String! {
        didSet {
            self.nameLabel.text = tabName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            self.nameLabel.backgroundColor = UIColor.lightGray
        } else {
            self.nameLabel.backgroundColor = UIColor.white
        }
    }

}
