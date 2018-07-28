//
//  DragViewDelegate.swift
//  DragView
//
//  Created by Trương Văn Kiên on 6/16/18.
//  Copyright © 2018 Trương Văn Kiên. All rights reserved.
//

import UIKit

@objc protocol DragViewDelegate: class {
    @objc optional func dragView(_ tableView: UITableView, didTapRowAt indexPath: IndexPath, at page: Int)
    
    @objc optional func dragView(_ tableView: UITableView, reArrangeItemAtIndexPath from: IndexPath, to: IndexPath, at page: Int)
    
    @objc optional func dragView(didDropItem from: IndexPath, fromTable: UITableView, to: IndexPath, toTable: UITableView, fromPage: Int, toPage: Int)
    
    @objc optional func dragView(_ collectionView: UICollectionView, didTapItemAt indexPath: IndexPath)
    
}
