//
//  DragViewController.swift
//  DragView
//
//  Created by Trương Văn Kiên on 6/14/18.
//  Copyright © 2018 Trương Văn Kiên. All rights reserved.
//

import UIKit

class DragViewController: UIViewController {
    private var pagesTabCollectionView: UICollectionView!
    private var pageWidth: CGFloat!
    private var pageHeight: CGFloat!
    
    private var navigationHeight: CGFloat!
    private var bottomPadding: CGFloat!
    private var topPadding: CGFloat!
    
    private var numberOfPage = 0
    private var lastPage = 0
    private var currentPage = 0
    
    private var currentDragLocation: CGPoint!
    private var lockedDragLocation: CGPoint!
    private var kTableViewCellHeight: CGFloat = 0
    
    private var tableViewCellIdentifier: String!
    private var pageTabCellIdentifier: String!
    
    let kCollectionViewCellHeight: CGFloat = 40
    let kCollectionViewCellWidth: CGFloat = 80
    
    var boardScrollView: UIScrollView!
    var dragCoordinator: I3GestureCoordinator!
    
    var shouldScrollBoard: Bool!
    var shouldScrollTable: Bool!
    
    var boardTables: [UITableView] = []
    //var boardTablesDataSource: [[String]] = [[]]
    
    var pageChangeDelay = 0.7
    var tableScrollDelay = 0.2
    var topBottomRange: CGFloat = 100.0
    var leftRightRange: CGFloat = 100.0
    
    weak var dataSource: DragViewDataSource?
    weak var delegate: DragViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.preparePaddingTopBottom()
        self.preparePageTabs()
        self.prepareBoardLayout()
        self.prepareAddButton()
    }
    
    @objc func didTapAddButton(_ sender: Any) {
//        let n = Int(arc4random_uniform(100))
//        boardTablesDataSource[currentPage].append("\(n)")
//        let tableView = boardTables[currentPage]
//        let newIndexPath = IndexPath(row: boardTablesDataSource[currentPage].count - 1, section: 0)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
//        tableView.endUpdates()
    }
    
    func reloadTable(atPage: Int) {
        boardTables[atPage].reloadData()
    }
    
    func reloadAllTable() {
        for tableView in boardTables {
            tableView.reloadData()
        }
    }
    
    private func preparePaddingTopBottom() {
        topPadding = 20
        bottomPadding = 0
        navigationHeight = 0
        if #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow {
            if window.safeAreaInsets.top > 0 && window.safeAreaInsets.bottom > 0 {
                topPadding = window.safeAreaInsets.top
                bottomPadding = window.safeAreaInsets.bottom
            }
        }
        if let navigationBar = self.navigationController?.navigationBar {
            navigationHeight = navigationBar.bounds.height
        }
        self.pageWidth = UIScreen.main.bounds.width
        self.pageHeight = UIScreen.main.bounds.height
    }
    
    private func prepareAddButton() {
        let addButton = UIButton(frame: CGRect(x: pageWidth - 56, y: UIScreen.main.bounds.height - 56, width: 40, height: 40))
        addButton.layer.cornerRadius = 20
        addButton.layer.masksToBounds = true
        addButton.backgroundColor = .red
        addButton.setTitle("+", for: .normal)
        addButton.addTarget(self, action: #selector(self.didTapAddButton(_:)), for: .touchUpInside)
        self.view.addSubview(addButton)
    }
    
    private func preparePageTabs() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        pagesTabCollectionView = UICollectionView(frame: CGRect(x: 0, y: topPadding + navigationHeight, width: pageWidth, height: kCollectionViewCellHeight), collectionViewLayout: layout)
        pagesTabCollectionView.backgroundColor = UIColor.white
        pagesTabCollectionView.delegate = self
        pagesTabCollectionView.dataSource = self
        if let identifier = dataSource?.cellIdentifier(for: pagesTabCollectionView) {
            self.pageTabCellIdentifier = identifier
            pagesTabCollectionView.register(UINib(nibName: pageTabCellIdentifier, bundle: nil), forCellWithReuseIdentifier: pageTabCellIdentifier)
        }
        pagesTabCollectionView.reloadData()
        self.view.addSubview(pagesTabCollectionView)
    }
    
    private func prepareBoardLayout() {
        let yAxit = kCollectionViewCellHeight + topPadding + navigationHeight
        let scrollHeight = pageHeight - kCollectionViewCellHeight - topPadding - bottomPadding - navigationHeight
        boardScrollView = UIScrollView(frame: CGRect(x: 0, y: yAxit, width: pageWidth, height: scrollHeight))
        if #available(iOS 11.0, *) {
            boardScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        boardScrollView.backgroundColor = UIColor.white
        boardScrollView.showsVerticalScrollIndicator = false
        boardScrollView.showsHorizontalScrollIndicator = false
        boardScrollView.delegate = self
        self.view.addSubview(boardScrollView)
        
        var boardTableFrame = CGRect(x: 0, y: 0, width: pageWidth, height: scrollHeight)
        
        if let numberOfPage = dataSource?.numberOfPage() {
            self.numberOfPage = numberOfPage
            for i in 0..<numberOfPage {
                boardTableFrame.origin.x = pageWidth * CGFloat(i)
                
                let boardTable = UITableView(frame: boardTableFrame, style: .plain)
                boardTable.backgroundColor = UIColor.clear
                if let identifier = dataSource?.cellIdentifier(for: boardTable, at: i) {
                    self.tableViewCellIdentifier = identifier
                    boardTable.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                }
                boardTable.separatorColor = UIColor.clear
                boardTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                boardTable.dataSource = self
                boardTable.delegate = self
                boardTable.tag = i
                
                boardTables.append(boardTable)
                boardScrollView.addSubview(boardTable)
                
                //let boardTableDataSource = [String]()
                //boardTablesDataSource.append(boardTableDataSource)
            }
        }
        boardScrollView.contentSize = CGSize(width: pageWidth * CGFloat(numberOfPage), height: scrollHeight)
        boardScrollView.isPagingEnabled = true
        
        // Gesture coordinator
        self.prepareDragGestureCoordinator()
        
        // Pages
        if (numberOfPage > 1) {
            lastPage = numberOfPage - 1;
        }
        
        shouldScrollBoard = true
        shouldScrollTable = true
        
        self.pageChanged()
    }
    
    private func prepareDragGestureCoordinator() {
        dragCoordinator = I3GestureCoordinator.basicGestureCoordinator(from: self, withCollections: boardTables, with: UILongPressGestureRecognizer(target: self, action: nil))
        
        let renderDelegate = self.dragCoordinator.renderDelegate as? I3BasicRenderDelegate
        renderDelegate?.rearrangeIsExchange = true
        renderDelegate?.draggingItemOpacity = 0.5
        
        let customDelegate = CustomDragRenderDelegate()
        dragCoordinator.renderDelegate = customDelegate
        customDelegate.callBacks = self
    }
    
    private func pageChanged() {
        let indexPath = IndexPath(item: currentPage, section: 0)
        delegate?.dragView?(pagesTabCollectionView, didTapItemAt: indexPath)
        pagesTabCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func scrollBoardLeft(_ left: Bool) {
        if !shouldScrollBoard {
            return
        }
        
        var newOffsetX: CGFloat = 0;
        
        if (left) {
            if (currentPage > 0) {
                let previousPage = currentPage - 1;
                newOffsetX = pageWidth * CGFloat(previousPage);
                
                shouldScrollBoard = false;
                DispatchQueue.main.asyncAfter(deadline: .now() + pageChangeDelay) {
                    if self.isLocationInLeftRegion() {
                        self.currentPage = previousPage;
                        self.boardScrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
                        self.pageChanged()
                    }
                    self.shouldScrollBoard = true
                }
            }
        } else {
            if currentPage < lastPage {
                let nextPage = currentPage + 1;
                newOffsetX = pageWidth * CGFloat(nextPage);
                
                shouldScrollBoard = false;
                DispatchQueue.main.asyncAfter(deadline: .now() + pageChangeDelay) {
                    if self.isLocationInRightRegion() {
                        self.currentPage = nextPage;
                        self.boardScrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
                        self.pageChanged()
                    }
                    self.shouldScrollBoard = true
                }
            }
        }
    }
    
    private func scrollTableTop(_ top: Bool) {
        if (!shouldScrollTable) {
            return
        }
        let tableView = boardTables[currentPage]
        
        if !self.canScrollTableView(tableView) {
            return
        }
        
        let currentOffsetY = tableView.contentOffset.y
        let minOffsetY: CGFloat = 0
        let maxOffsetY = tableView.contentSize.height - tableView.frame.size.height
        
        if (top) {
            if (currentOffsetY > minOffsetY) {
                shouldScrollTable = false;
                DispatchQueue.main.asyncAfter(deadline: .now() + tableScrollDelay) {
                    if self.isLocationToTopOfTableView() {
                        tableView.setContentOffset(CGPoint(x: 0, y: currentOffsetY - self.kTableViewCellHeight), animated: true)
                    }
                    self.shouldScrollTable = true
                }
            }
        } else {
            if (currentOffsetY < maxOffsetY) {
                shouldScrollTable = false;
                DispatchQueue.main.asyncAfter(deadline: .now() + tableScrollDelay) {
                    if self.isLocationToBottomOfTableView() {
                        tableView.setContentOffset(CGPoint(x: 0, y: currentOffsetY + self.kTableViewCellHeight), animated: true)
                    }
                    self.shouldScrollTable = true
                }
            }
        }
    }
    
    private func canScrollTableView(_ tableView: UITableView) -> Bool {
        if tableView.contentSize.height > tableView.frame.size.height {
            return true
        }
        return false
    }
    
    private func isLocationInRightRegion() -> Bool {
        let range = pageWidth - leftRightRange
        if (dragCoordinator.currentDragLocation.x > range) {
            return true
        }
        return false
    }
    
    private func isLocationInLeftRegion() -> Bool {
        let range = leftRightRange
        if (dragCoordinator.currentDragLocation.x < range) {
            return true
        }
        return false
    }
    
    private func isLocationToTopOfTableView() -> Bool {
        let minX: CGFloat = leftRightRange
        let maxX: CGFloat = pageWidth - leftRightRange
        let minY: CGFloat = topBottomRange
        let maxY = minY + topBottomRange + CGFloat(64 + 40)
        
        if currentDragLocation.x > minX && currentDragLocation.x < maxX {
            if currentDragLocation.y >= minY && currentDragLocation.y <= maxY {
                return true
            }
        }
        return false
    }
    
    private func isLocationToBottomOfTableView() -> Bool {
        let minX = leftRightRange
        let maxX = pageWidth - leftRightRange;
        let screenHeight = UIScreen.main.bounds.height
        let maxY = screenHeight
        let minY = maxY - topBottomRange
        
        if currentDragLocation.x > minX && currentDragLocation.x < maxX {
            if currentDragLocation.y >= minY && currentDragLocation.y <= maxY {
                return true
            }
        }
        return false
    }
    
    deinit {
        print("de init")
    }
}

extension DragViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == boardScrollView) {
            let offset = scrollView.contentOffset;
            let offsetX = offset.x;
            let pageWidth = boardScrollView.frame.size.width;
            currentPage = Int(offsetX/pageWidth);
            self.pageChanged()
        }
    }
}

extension DragViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(tableView, at: tableView.tag) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRow = dataSource?.dragTableView(tableView, numberOfRowIn: section, at: tableView.tag) {
            return numberOfRow
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource?.dragTableView(tableView, cellForRowAt: indexPath, at: tableView.tag) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.dragView?(tableView, didTapRowAt: indexPath, at: tableView.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = dataSource?.dragTableView(tableView, heightForRowAt: indexPath, at: tableView.tag) {
            self.kTableViewCellHeight = height
        }
        return kTableViewCellHeight
    }
}

extension DragViewController: I3DragDataSource {
    func canItemBeDragged(at: IndexPath!, inCollection collection: (UIView & I3Collection)!) -> Bool {
        return true
    }
    
    func canItem(from: IndexPath!, beRearrangedWithItemAt to: IndexPath!, inCollection collection: (UIView & I3Collection)!) -> Bool {
        return true
    }
    
    func canItem(at from: IndexPath!, beDeletedFromCollection collection: (UIView & I3Collection)!, at to: CGPoint) -> Bool {
        return true
    }
    
    func canItem(at from: IndexPath!, fromCollection: (UIView & I3Collection)!, beDroppedAt at: CGPoint, onCollection toCollection: (UIView & I3Collection)!) -> Bool {
        return true
    }
    
    func rearrangeItem(at from: IndexPath!, withItemAt to: IndexPath!, inCollection collection: (UIView & I3Collection)!) {
        let targetTableView = collection as! UITableView
        delegate?.dragView?(targetTableView, reArrangeItemAtIndexPath: from, to: to, at: targetTableView.tag)
    }
    
    func dropItem(at from: IndexPath!, fromCollection: (UIView & I3Collection)!, toItemAt to: IndexPath!, onCollection toCollection: (UIView & I3Collection)!) {
        let fromTable = fromCollection as! UITableView
        let toTable = toCollection as! UITableView
        delegate?.dragView?(didDropItem: from, fromTable: fromTable, to: to, toTable: toTable, fromPage: fromTable.tag, toPage: toTable.tag)
    }
    
    func dropItem(at from: IndexPath!, fromCollection: (UIView & I3Collection)!, to: CGPoint, onCollection toCollection: (UIView & I3Collection)!) {
        let position = Int(to.y / kTableViewCellHeight)
        let toIndex = IndexPath(item: position, section: 0)
        self.dropItem(at: from, fromCollection: fromCollection, toItemAt: toIndex, onCollection: toCollection)
    }
    
}

extension DragViewController: DragCallbacks {
    func draggingForm(_ coordinator: I3GestureCoordinator?) {
        currentDragLocation = coordinator?.currentDragLocation
        
        let minX:CGFloat = leftRightRange
        let maxX: CGFloat = pageWidth - leftRightRange
        
        if currentDragLocation.x < minX && shouldScrollBoard {
            lockedDragLocation = currentDragLocation
            self.scrollBoardLeft(true)
        } else if currentDragLocation.x > maxX && shouldScrollBoard {
            lockedDragLocation = currentDragLocation
            self.scrollBoardLeft(false)
        } else if self.isLocationToTopOfTableView() {
            self.scrollTableTop(true)
        } else if self.isLocationToBottomOfTableView() {
            self.scrollTableTop(false)
        }
    }
}

extension DragViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource?.tabbar(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataSource?.tabbar(collectionView, sizeForItemAt: indexPath) ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPage = indexPath.item
        let newOffsetX = pageWidth * CGFloat(currentPage)
        boardScrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
        self.pageChanged()
    }
}
