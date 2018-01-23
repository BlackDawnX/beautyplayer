//
//  BPNavigationBar.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/21.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class BPNavigationBar: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    class func viewFromNib() -> Any {
        let array = Bundle.main.loadNibNamed("BPNavigationBar", owner: nil, options: nil)
        return array![0]
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}
