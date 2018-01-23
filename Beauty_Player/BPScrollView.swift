//
//  BPScrollView.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/20.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

let leftViewWidth: CGFloat = 480
let leftViewContentWidth: CGFloat = 240

class BPScrollView: UIScrollView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var ges: UIPanGestureRecognizer?
    var leftView: BPLeftView?
    var back: UIView?
    
    private var leftTableView: UITableView?
    
    private var initialPosition: CGPoint = CGPoint()
    private var isLeftViewHidden = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        ges = UIPanGestureRecognizer(target: self, action: #selector(BPScrollView.pan(gesture:)))
//        ges?.delegate = self
//        self.addGestureRecognizer(ges!)
        
//        leftView = BPLeftView(frame: CGRect(x: -leftViewWidth, y: 0, width: leftViewWidth, height: SCREEN_HEIGHT))
//        leftView?.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
//     
//        back = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
//        back?.isUserInteractionEnabled = false
//        
//        self.addSubview(leftView!)
        
//        leftTableView = UITableView(frame: CGRect(x: leftViewContentWidth, y: 44, width: 230, height: 500), style: .plain)
//        leftTableView?.delegate = self
//        leftTableView?.dataSource = self
//        
//        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
//        aView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
//        
//        leftTableView?.backgroundView = aView
//        
//        self.leftView?.addSubview(leftTableView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pan(gesture: UIPanGestureRecognizer) {
        self.gesture(gesture)
    }
    
    @objc private func leftViewPan(gesture: UIPanGestureRecognizer) {
        print("=====")
    }
    
    private func gesture(_ gesture: UIPanGestureRecognizer) {
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(leftView!)
        
        if gesture.state == .began {
            //获取leftView初始位置
            initialPosition.x = (self.leftView?.center.x)!
        }
        
        let point = gesture.translation(in: self)
        print(point)
        if (leftView?.center.x)! <= CGFloat(0) {
            if isLeftViewHidden {
                if point.x >= 0 && point.x <= 500 {
                    leftView?.center = CGPoint(x: initialPosition.x + point.x , y: (leftView?.center.y)!)
                }
            } else {
                leftView?.center = CGPoint(x: initialPosition.x + point.x , y: (leftView?.center.y)!)
            }
        } else if (leftView?.center.x)! > CGFloat(0) {
            if isLeftViewHidden {
                if point.x >= 0 && point.x <= 500 {
                    leftView?.center = CGPoint(x: initialPosition.x + point.x , y: (leftView?.center.y)!)
                }
            } else {
                leftView?.center = CGPoint(x: initialPosition.x + point.x, y: (leftView?.center.y)!)
            }
        }
        
        if gesture.state == .ended {
            if isLeftViewHidden {
                
                if (leftView?.center.x)! <= CGFloat(-220) {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.leftView?.frame = CGRect(x: -leftViewWidth, y: 0, width: leftViewWidth, height: self.frame.size.height);
                    }, completion: { (finished) in
                        
                    })
                    
                    isLeftViewHidden = true
                    
                } else if (leftView?.center.x)! > CGFloat(-220) && (leftView?.center.x)! <= CGFloat(300) {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.leftView?.frame = CGRect(x: -240, y: 0, width: leftViewWidth, height: self.frame.size.height);
                    }, completion: { (finished) in
                        
                    })
                    
                    isLeftViewHidden = false
                    leftView?.isLeftViewHidden = false
                }
                
            } else {
                
                if (leftView?.center.x)! <= CGFloat(-50) {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.leftView?.frame = CGRect(x: -leftViewWidth, y: 0, width: leftViewWidth, height: self.frame.size.height);
                    }, completion: { (finished) in
                        
                    })
                    
                    isLeftViewHidden = true
                    
                } else if (leftView?.center.x)! > CGFloat(-50) && (leftView?.center.x)! <= CGFloat(300) {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.leftView?.frame = CGRect(x: -240, y: 0, width: leftViewWidth, height: self.frame.size.height);
                    }, completion: { (finished) in
                        
                    })
                    
                    isLeftViewHidden = false
                    leftView?.isLeftViewHidden = false
                }
            }
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.panGestureRecognizer {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let point = pan.translation(in: self)
            let state = pan.state
            
            if state == UIGestureRecognizerState.began || state == UIGestureRecognizerState.possible {
                let location = pan.location(in: self)
                if point.x < 0 && location.x < self.frame.size.width && self.contentOffset.x <= 0 {
                    
                    return true
                }
            }
        }
        
        return false
    }

    // MARK: - UITableView Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "leftCell")
        
        cell.textLabel?.text = "23333"
        cell.textLabel?.textColor = UIColor.white
        
        cell.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        
        return cell
    }
    
    
    
}
