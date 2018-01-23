//
//  BPFunctionListView.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/23.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class BPFunctionListView: UIView {

    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var linkToServer: UIButton!
     
    @IBOutlet weak var settings: UIButton!
    
    override func awakeFromNib() {
        if UIScreen.main.bounds.size.width > 400 {
            self.constraintWidth.constant = 400
        }

        self.layoutIfNeeded()
        
        linkToServer.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        linkToServer.setBackgroundImage(image(with: UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)), for: .highlighted)
        settings.setBackgroundImage(image(with: UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)), for: .highlighted)
    }

    func image(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
 
