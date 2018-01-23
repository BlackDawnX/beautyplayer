//
//  BPCollectionView.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/15.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

@objc protocol RTDragCellTableViewDataSource: UICollectionViewDataSource {
    @objc func originalArrayDataForTableView(tableView: BPCollectionView) -> NSArray
}

@objc protocol RTDragCellTableViewDelegate: UICollectionViewDelegate {
    /**将修改重排后的数组传入，以便外部更新数据源*/
    @objc func tableView(tableView: BPCollectionView, newArrayDataForDataSource newArray: NSArray)
    /**选中的cell准备好可以移动的时候*/
    @objc func tableView(tableView: BPCollectionView, cellReadyToMoveAtIndexPath indexPath: IndexPath)
    /**选中的cell正在移动，变换位置，手势尚未松开*/
    @objc func cellIsMovingInTableView(tableView: BPCollectionView)
    /**选中的cell完成移动，手势已松开*/
    @objc func cellDidEndMovingInTableView(tableView: BPCollectionView)
}

class BPCollectionView: UICollectionView {
    
    enum RTSnapshotMeetsEdge{
        case top
        case bottom
    }
    
    var adataSource: RTDragCellTableViewDataSource?
    var adelegate: RTDragCellTableViewDelegate?
    
    /**记录手指所在的位置*/
    var fingerLocation: CGPoint?
    
    /**被选中的cell的新位置*/
    var relocatedIndexPath: IndexPath?
    
    /**被选中的cell的原始位置*/
    var originalIndexPath: IndexPath?
    
    /**对被选中的cell的截图*/
    var snapshot: UIView?
    
    /**自动滚动的方向*/
    var autoScrollDirection: RTSnapshotMeetsEdge?
    
    /**cell被拖动到边缘后开启，tableview自动向上或向下滚动*/
    var autoScrollTimer: CADisplayLink?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(BPCollectionView.longPressGestureRecognized(sender:)))
        self.addGestureRecognizer(longPress)
        
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func longPressGestureRecognized(sender: UILongPressGestureRecognizer) {
        let longPressState = sender.state
        fingerLocation = sender.location(in: self)
        relocatedIndexPath = self.indexPathForItem(at: fingerLocation!)
        
        switch longPressState {
        case .began:
            originalIndexPath = self.indexPathForItem(at: fingerLocation!)
            if originalIndexPath != nil {
                self.cellSelectedAtIndexPath(indexPath: originalIndexPath!)
            }
            
            break
        case .changed:
            var center = snapshot?.center
            center?.x = (fingerLocation?.x)!
            center?.y = (fingerLocation?.y)!
            snapshot?.center = center!
            
            if self.checkIfSnapshotMeetsEdge() {
                self.startAutoScrollTimer()
            } else {
                self.stopAutoScrollTimer()
            }
            
            relocatedIndexPath = self.indexPathForItem(at: fingerLocation!)
            if relocatedIndexPath != nil && !(relocatedIndexPath?.elementsEqual(originalIndexPath!))! {
                self.cellRelocatedToNewIndexPath(indexPath: relocatedIndexPath!)
            }
            break
        case .ended:
            self.stopAutoScrollTimer()
            self.didEndDraging()
            if (self.adelegate?.responds(to: #selector(RTDragCellTableViewDelegate.cellDidEndMovingInTableView(tableView:))))! {
                self.adelegate?.cellDidEndMovingInTableView(tableView: self)
            }
            break
            
        default:
            self.stopAutoScrollTimer()
            self.didEndDraging()
        }
    }
    
    
    /**
     *  cell被长按手指选中，对其进行截图，原cell隐藏
     */
    func cellSelectedAtIndexPath(indexPath: IndexPath) {
        let cell = self.cellForItem(at: indexPath)
        let snapshot = self.customSnapshotFromView(inputView: cell!)
        snapshot.isUserInteractionEnabled = true
        self.addSubview(snapshot)
        self.snapshot = snapshot
        cell?.isHidden = true
        
        var center = self.snapshot?.center
        center?.y = (fingerLocation?.y)!
        UIView.animate(withDuration: 0.2) { 
            self.snapshot?.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
            self.snapshot?.alpha = 0.98
            self.snapshot?.center = center!
        }
    }
    
    /** 返回一个给定view的截图. */
    func customSnapshotFromView(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.center = inputView.center
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
    
    /**
     *  检查截图是否到达边缘，并作出响应
     */
    func checkIfSnapshotMeetsEdge() -> Bool {
        let minY = self.snapshot?.frame.minY
        let maxY = self.snapshot?.frame.maxY
        
        if minY! < self.contentOffset.y {
            autoScrollDirection = .top
            return true
        }
        if maxY! > self.bounds.size.height + self.contentOffset.y {
            autoScrollDirection = .bottom
            return true
        }
        
        return false
    }
    
    /**
     *  创建定时器并运行
     */
    func startAutoScrollTimer() {
        if !(autoScrollTimer != nil) {
            autoScrollTimer = CADisplayLink(target: self, selector: #selector(BPCollectionView.startAutoScroll))
            autoScrollTimer?.add(to: RunLoop.main, forMode: .commonModes)
        }
    }
    
    /**
     *  停止定时器并销毁
     */
    func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    /**
     *  开始自动滚动
     */
    func startAutoScroll() {
        let pixelSpeed: CGFloat = 4
        if autoScrollDirection == .top {
            if self.contentOffset.y > 0 {
                self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y - pixelSpeed), animated: false)
                snapshot?.center = CGPoint(x: (snapshot?.center.x)!, y: (snapshot?.center.y)! - pixelSpeed)
            }
        } else {
            if self.contentOffset.y + self.bounds.size.height < self.contentSize.height {//向下滚动最大范围限制
                self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y + pixelSpeed), animated: false)
                snapshot?.center = CGPoint(x: (snapshot?.center.x)!, y: (snapshot?.center.y)! + pixelSpeed)
            }
        }
        
        relocatedIndexPath = self.indexPathForItem(at: (snapshot?.center)!)
        if relocatedIndexPath != nil && !(relocatedIndexPath?.elementsEqual(originalIndexPath!))! {
            self.cellRelocatedToNewIndexPath(indexPath: relocatedIndexPath!)
        }
    }
    
    
    /**
     *  截图被移动到新的indexPath范围，这时先更新数据源，重排数组，再将cell移至新位置
     */
    func cellRelocatedToNewIndexPath(indexPath: IndexPath) {
        self.updateDataSource()
        self.moveItem(at: originalIndexPath!, to: indexPath)
        originalIndexPath = indexPath
    }
    
    /**修改数据源，通知外部更新数据源*/
    func updateDataSource() {
        let tempArray = NSMutableArray()
        if (self.adataSource?.responds(to: #selector(RTDragCellTableViewDataSource.originalArrayDataForTableView(tableView:))))! {
            tempArray.addingObjects(from: self.adataSource?.originalArrayDataForTableView(tableView: self) as! [Any])
        }
        //不是嵌套数组
        self.moveObjectInMutableArray(array: tempArray, fromIndex: (originalIndexPath?.row)!, toIndex: (relocatedIndexPath?.row)!)
        if (self.adelegate?.responds(to: #selector(RTDragCellTableViewDelegate.tableView(tableView:newArrayDataForDataSource:))))! {
            self.adelegate?.tableView(tableView: self, newArrayDataForDataSource: tempArray)
        }

    }
    
    
    /**
     *  将可变数组中的一个对象移动到该数组中的另外一个位置
     *  @param array     要变动的数组
     *  @param fromIndex 从这个index
     *  @param toIndex   移至这个index
     */
    func moveObjectInMutableArray(array: NSMutableArray, fromIndex: NSInteger, toIndex: NSInteger) {
        if fromIndex < toIndex {
            for i in fromIndex..<toIndex {
                array.exchangeObject(at: i, withObjectAt: i + 1)
            }
        } else {
            for i in toIndex..<fromIndex {
                array.exchangeObject(at: i, withObjectAt: i - 1)
            }
        }
    }
    
    
    /**
     *  拖拽结束，显示cell，并移除截图
     */
    func didEndDraging() {
        let cell = self.cellForItem(at: originalIndexPath!)
        cell?.isHidden = false
        cell?.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: { 
            self.snapshot?.center = (cell?.center)!
            self.snapshot?.alpha = 0
            self.snapshot?.transform = CGAffineTransform.identity
        }) { (finished) in
            cell?.isHidden = false
            self.snapshot?.removeFromSuperview()
            self.snapshot = nil;
            self.originalIndexPath = nil;
            self.relocatedIndexPath = nil;
        }
    }
    
}
