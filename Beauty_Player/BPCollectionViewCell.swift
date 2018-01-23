//
//  BPCollectionViewCell.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/15.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class BPCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attributesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setDataFromModel(model: BPModel?) {
        cover.image = UIImage(named: "000.png")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
