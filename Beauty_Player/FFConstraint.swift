//
//  BPConstraint.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/26.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class FFConstraint: NSObject {

    /**使控件充满整个父视图*/
    class func fillScreen(item: Any, toItem: Any?) -> [NSLayoutConstraint] {
        let constraintTop = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1.0, constant: 0)
        let constraintBottom = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1.0, constant: 0)
        let constraintLeft = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: 1.0, constant: 0)
        let constraintRight = NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: toItem, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        return [constraintTop, constraintBottom, constraintLeft, constraintRight]
    }
    
    /**所有参数为 0 时使控件充满整个父视图，否则将会产生一定距离*/
    class func fillOffSet(item: Any, toItem: Any, topOffSet: CGFloat, bottomOffSet: CGFloat, leadingOffSet: CGFloat, trailingOffSet: CGFloat) -> [NSLayoutConstraint] {
        let constraintTop = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1.0, constant: topOffSet)
        let constraintBottom = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1.0, constant: bottomOffSet)
        let constraintLeft = NSLayoutConstraint(item: toItem, attribute: .leading, relatedBy: .equal, toItem: item, attribute: .leading, multiplier: 1.0, constant: leadingOffSet)
        let constraintRight = NSLayoutConstraint(item: toItem, attribute: .trailing, relatedBy: .equal, toItem: item, attribute: .trailing, multiplier: 1.0, constant: trailingOffSet)
        
        return [constraintTop, constraintBottom, constraintLeft, constraintRight]
    }
    
    /**固定一个控件的宽和高*/
    class func size(width: CGFloat, height: CGFloat, item: Any) -> [NSLayoutConstraint]  {
        let constraintWidth = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        let constraintHeight = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        
        return [constraintWidth, constraintHeight]
    }
    
    /**在父视图居中*/
    class func centerScreen(item: Any, toItem: Any?) -> [NSLayoutConstraint] {
        let constraintCenterX = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: toItem, attribute: .centerX, multiplier: 1.0, constant: 0)
        let constraintCenterY = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: toItem, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        return [constraintCenterX, constraintCenterY]
    }
    
    /**
     在父视图居中，且能够设置偏移量
     
     - parameters:
        - x: x 方向的偏移量
        - y: y 方向的偏移量
     */
    class func centerScreenOffSet(item: Any, toItem: Any?, x: CGFloat, y: CGFloat) -> [NSLayoutConstraint] {
        let constraintCenterX = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: toItem, attribute: .centerX, multiplier: 1.0, constant: x)
        let constraintCenterY = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: toItem, attribute: .centerY, multiplier: 1.0, constant: y)
        
        return [constraintCenterX, constraintCenterY]
    }
    
    /**
     使控件在父视图中置顶，且固定高，宽度与屏幕宽度相等
     
     # 要使该约束有效，你还需要对约束对象限制一个固定高度
     
     - parameters:
        - top: 距离 top 的距离
        - height: 控件的高度
     */
    class func topOffSet(item: Any, toItem: Any?, top: CGFloat) -> [NSLayoutConstraint] {
        let constraintTop = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1, constant: top)
        let constraintLeft = NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: toItem, attribute: .left, multiplier: 1, constant: 0)
        let constraintRight = NSLayoutConstraint(item: item, attribute: .right, relatedBy: .equal, toItem: toItem, attribute: .right, multiplier: 1, constant: 0)
        
        return [constraintTop, constraintLeft, constraintRight]
    }
}
