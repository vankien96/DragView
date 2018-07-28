//
//  TestViewController.swift
//  DragView
//
//  Created by Trương Văn Kiên on 6/15/18.
//  Copyright © 2018 Trương Văn Kiên. All rights reserved.
//

import UIKit

class TestViewController: DragViewController {

    var dataForDragView: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataForDragView = [["1","2","3"], ["4","5","6"],["7","8","9"]]
        self.dataSource = self
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension TestViewController: DragViewDataSource {
    func cellIdentifier(for tableView: UITableView, at page: Int) -> String {
        return "DragTableViewCell"
    }
    
    func dragTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, at page: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DragTableViewCell", for: indexPath) as! DragTableViewCell
        cell.titleLabel.text = "Item \(dataForDragView[page][indexPath.row])"
        return cell
    }
    
    func numberOfSections(_ dragTableView: UITableView, at page: Int) -> Int {
        return 1
    }
    
    func dragTableView(_ tableView: UITableView, numberOfRowIn section: Int, at page: Int) -> Int {
        return dataForDragView[page].count
    }
    
    func dragTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath, at page: Int) -> CGFloat {
        return 110
    }
    
    func numberOfPage() -> Int {
        return dataForDragView.count
    }
    
    func cellIdentifier(for tabbar: UICollectionView) -> String {
        return "PageTabCell"
    }
    
    func tabbar(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageTabCell", for: indexPath) as! PageTabCell
        cell.nameLabel.text = "Trang \(indexPath.item + 1)"
        return cell
    }
    
    func tabbar(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}

extension TestViewController: DragViewDelegate {
    func dragView(_ tableView: UITableView, reArrangeItemAtIndexPath from: IndexPath, to: IndexPath, at page: Int) {
        let data = dataForDragView[page].remove(at: from.row)
        dataForDragView[page].insert(data, at: to.row)
        print(dataForDragView)
        tableView.reloadSections(IndexSet([0]), with: .none)
    }
    
    func dragView(didDropItem from: IndexPath, fromTable: UITableView, to: IndexPath, toTable: UITableView, fromPage: Int, toPage: Int) {
        var toIndex = IndexPath(row: to.row, section: 0)
        let toDataSet = dataForDragView[toPage]
        if to.row > toDataSet.count {
            toIndex = IndexPath(row: toDataSet.count, section: 0)
        }
        
        let data = dataForDragView[fromPage].remove(at: from.row)
        print(dataForDragView)
        dataForDragView[toPage].insert(data, at: toIndex.row)
        print(dataForDragView)
        
        print(dataForDragView[fromPage])
        fromTable.deleteRows(at: [from], with: .fade)
        toTable.insertRows(at: [toIndex], with: .fade)
    }
    
    func dragView(_ collectionView: UICollectionView, didTapItemAt indexPath: IndexPath) {
        
    }
}
