//
//  BPMainViewController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/15.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class BPMainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate, RTDragCellTableViewDelegate, RTDragCellTableViewDataSource {

    let screenSize = UIScreen.main.bounds.size
    
    var arr = ["1", "2", "3", "4"]
    var contentArr: [[String: Any]] = []
    
    var playerDelegate: BPPlayerDelegate?
    
    private var bpCollectionView: UICollectionView?
    private var visualEffectView: UIVisualEffectView?

    private let collectionCellHeight_Phone: CGFloat = 250
    private let collectionCellHeight_Pad: CGFloat = 320
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(BPMainViewController.reloadData), name: NSNotification.Name.SharedFile, object: nil)
        
        self.view.backgroundColor = UIColor.white
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .vertical
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            flowLayout.itemSize = CGSize(width: screenSize.width - 20, height: collectionCellHeight_Phone)
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            flowLayout.itemSize = CGSize(width: screenSize.width/3 - 30, height: collectionCellHeight_Pad)
        }
        
        self.bpCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        self.bpCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.bpCollectionView?.register(UINib(nibName: "BPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.bpCollectionView?.delegate = self
        self.bpCollectionView?.dataSource = self
        self.bpCollectionView?.alwaysBounceVertical = true
        self.bpCollectionView?.backgroundColor = UIColor.white
        self.bpCollectionView?.contentInset = UIEdgeInsets(top: 54, left: 0, bottom: 20, right: 0)
        self.bpCollectionView?.backgroundColor = THEME_COLOR
        
        self.view.addSubview(self.bpCollectionView!)
        
        self.view.addConstraints(FFConstraint.fillScreen(item: self.bpCollectionView, toItem: self.bpCollectionView?.superview))
        
        self.loadData()
        self.bpCollectionView?.reloadData()
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView?.translatesAutoresizingMaskIntoConstraints = false
        self.visualEffectView?.layer.opacity = 0
        
        self.view.insertSubview(self.visualEffectView!, at: 10)
        
        let constraintTop = NSLayoutConstraint(item: self.visualEffectView!, attribute: .top, relatedBy: .equal, toItem: self.visualEffectView!.superview, attribute: .top, multiplier: 1, constant: 0)
        let constraintLeft = NSLayoutConstraint(item: self.visualEffectView!, attribute: .left, relatedBy: .equal, toItem: self.visualEffectView!.superview, attribute: .left, multiplier: 1, constant: 0)
        let constraintRight = NSLayoutConstraint(item: self.visualEffectView!, attribute: .right, relatedBy: .equal, toItem: self.visualEffectView!.superview, attribute: .right, multiplier: 1, constant: 0)
        let constraintBottom = NSLayoutConstraint(item: self.visualEffectView!, attribute: .bottom, relatedBy: .equal, toItem: self.visualEffectView!.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints(FFConstraint.fillScreen(item: self.visualEffectView, toItem: self.view))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            return .portrait
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            return [.landscapeLeft, .landscapeRight]
        }
        
        return .portrait
    }
        
    private var lastComponent: CGFloat = 0.0
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastComponent = scrollView.contentOffset.x
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print(lastComponent < scrollView.contentOffset.x)
    }
    
    @objc private func pan(gesture: UIPanGestureRecognizer) {
        print(gesture.translation(in: self.bpCollectionView))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == (self.bpCollectionView?.panGestureRecognizer)! {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let point = pan.translation(in: self.bpCollectionView)
            let state = pan.state
            
            if state == UIGestureRecognizerState.began || state == UIGestureRecognizerState.possible {
                let location = pan.location(in: self.bpCollectionView)
                if point.x < 0 && location.x < self.bpCollectionView!.frame.size.width && self.bpCollectionView!.contentOffset.x <= 0 {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    private func loadData() {
        let FM = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let inboxPath = "\(path!)/Inbox"
        
        do {
            let contentArr = try FM.contentsOfDirectory(at: URL(fileURLWithPath: path!),
                                                        includingPropertiesForKeys: nil,
                                                        options: FileManager.DirectoryEnumerationOptions.init(rawValue: 0))

            for url in contentArr {
                if BPPlayerViewController.isExtensionSupport(ext: url.pathExtension) {
                    let attr = try FM.attributesOfItem(atPath: url.path)
                    
                    let encodePath = url.path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    
                    let newDict = ["name": url.lastPathComponent,
                                   "type": url.pathExtension,
                                   "size": attr[FileAttributeKey.size] as? Int ?? 0,
                                   "path": encodePath ?? ""] as [String : Any]
                    
                    if url.lastPathComponent != "Inbox" {
                        self.contentArr.append(newDict)
                    }
                }
            }
        } catch {

        }
        
        if FM.fileExists(atPath: inboxPath) {
            do {
                let contentArr = try FM.contentsOfDirectory(at: URL(fileURLWithPath: inboxPath),
                                                            includingPropertiesForKeys: nil,
                                                            options: FileManager.DirectoryEnumerationOptions.init(rawValue: 0))
                
                for url in contentArr {
                    if BPPlayerViewController.isExtensionSupport(ext: url.pathExtension) {
                        let attr = try FM.attributesOfItem(atPath: url.path)
                        
                        let encodePath = url.path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        
                        let newDict = ["name": url.lastPathComponent,
                                       "type": url.pathExtension,
                                       "size": attr[FileAttributeKey.size] as? Int ?? 0,
                                       "path": encodePath ?? ""] as [String : Any]
                        self.contentArr.append(newDict)
                    }
                }
            } catch {
                
            }
        }
    }
    
    @objc private func reloadData() {
        self.contentArr = []
        self.loadData()
        self.bpCollectionView?.reloadData()
    }
    
    /**选中的cell完成移动，手势已松开*/
    @objc internal func cellDidEndMovingInTableView(tableView: BPCollectionView) {
        
    }
    
    /**选中的cell正在移动，变换位置，手势尚未松开*/
    @objc internal func cellIsMovingInTableView(tableView: BPCollectionView) {
        
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BPCollectionViewCell
        cell.setDataFromModel(model: nil)
        cell.titleLabel.text = contentArr[indexPath.row]["name"] as! String?
        
        let fileSize = contentArr[indexPath.row]["size"] as! Int
        if fileSize <= 1024 {
            // <1 KB
            cell.attributesLabel.text = "\(Int(fileSize)) B"
        } else if fileSize > 1024 && fileSize <= 1024*1024 {
            // <1 MB
            cell.attributesLabel.text = "\(Int(fileSize/1024)) KB"
        } else if fileSize > 1024*1024 && fileSize <= 1024*1024*1024 {
            // <1 GB
            cell.attributesLabel.text = "\(Int(fileSize/1024/1024)) MB"
        } else {
            // >1 GB
            cell.attributesLabel.text = "\(Int(fileSize/1024/1024/1024)) GB"
        }
        
        return cell
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentArr.count
    }
    
    /**选中的cell准备好可以移动的时候*/
    @objc internal func tableView(tableView: BPCollectionView, cellReadyToMoveAtIndexPath indexPath: IndexPath) {
        
    }
    
    /**将修改重排后的数组传入，以便外部更新数据源*/
    @objc internal func tableView(tableView: BPCollectionView, newArrayDataForDataSource newArray: NSArray) {
        self.arr = newArray as! Array
    }
    
    @objc internal func originalArrayDataForTableView(tableView: BPCollectionView) -> NSArray {
        return self.arr as NSArray
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            return CGSize(width: screenSize.width - 20, height: collectionCellHeight_Phone)
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            return CGSize(width: screenSize.width/3 - 30, height: collectionCellHeight_Pad)
        }
        return CGSize(width: screenSize.width - 20, height: collectionCellHeight_Phone)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
//        UIView.animate(withDuration: 0.2, animations: { 
////            self.visualEffectView?.layer.opacity = 1
//        }) { (finished) in
//            let playViewController = BPPlayerViewController(filePath: self.contentArr[indexPath.row]["path"] as! String)
//            self.present(playViewController, animated: true, completion: nil)
//        }
        
        self.playerDelegate?.bpPlayer(didSelectedToPlay: self.contentArr[indexPath.row]["path"] as! String)
    }
}


extension Notification.Name {
    static let SharedFile = Notification.Name.init("SharedFile")
}




