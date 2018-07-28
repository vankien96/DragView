//
//  DragViewDataSource.swift
//  DragView
//
//  Created by Trương Văn Kiên on 6/15/18.
//  Copyright © 2018 Trương Văn Kiên. All rights reserved.
//

import UIKit

@objc protocol DragViewDataSource: class {
    func cellIdentifier(for tableView: UITableView, at page: Int) -> String
    
    func dragTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, at page: Int) -> UITableViewCell
    
    func numberOfSections(_ dragTableView: UITableView, at page: Int) -> Int
    
    func dragTableView(_ tableView: UITableView, numberOfRowIn section: Int, at page: Int) -> Int
    
    func dragTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath, at page: Int) -> CGFloat
    
    func numberOfPage() -> Int
    
    func cellIdentifier(for tabbar: UICollectionView) -> String
    
    func tabbar(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func tabbar(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
}
