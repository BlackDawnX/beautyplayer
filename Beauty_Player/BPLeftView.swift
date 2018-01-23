//
//  BPLeftView.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/20.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

protocol LeftViewPanGestureRecognizerDelegate {
    func backViewOpacity(opacity: CGFloat)
}

class BPLeftView: UIView {

//    var leftViewPanGestureRecognizerDelegate: LeftViewPanGestureRecognizerDelegate?
    
    var initialPosition: CGPoint = CGPoint()
    
    public var isLeftViewHidden = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let leftViewGesture = UIPanGestureRecognizer(target: self, action: #selector(BPLeftView.leftViewPan(gesture:)))
//        leftViewGesture.delegate = self
        self.addGestureRecognizer(leftViewGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func leftViewPan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            //获取leftView初始位置
            initialPosition.x = self.center.x
        }
        
        let point = gesture.translation(in: self)
        
        if self.center.x <= CGFloat(0) {
            if point.x <= 300 {
                self.center = CGPoint(x: initialPosition.x + point.x , y: self.center.y)

            }
        } else if self.center.x > CGFloat(0) {
            if point.x <= 300 {
                self.center = CGPoint(x: initialPosition.x + point.x, y: self.center.y)

            }
        }
        
        if gesture.state == .ended {
            
                if self.center.x <= CGFloat(-50) {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.frame = CGRect(x: -leftViewWidth, y: 0, width: leftViewWidth, height: self.frame.size.height);
                    }, completion: { (finished) in
                        
                    })
                    
                    isLeftViewHidden = true
                    
                } else if self.center.x > CGFloat(-50) && self.center.x <= CGFloat(300) {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.frame = CGRect(x: -240, y: 0, width:leftViewWidth, height: self.frame.size.height);
                    }, completion: { (finished) in
                        
                    })
                    
                    isLeftViewHidden = false
                }
        }

    }
}
