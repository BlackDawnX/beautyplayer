//
//  BPModel.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/15.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class BPModel: NSObject, NSCoding {
    
    var image: String?
    var title: String?
    var filePath: String?
    
    public required init?(coder aDecoder: NSCoder) {
        image = aDecoder.decodeObject(forKey: "BPModel_image") as! String?
        title = aDecoder.decodeObject(forKey: "BPModel_title") as! String?
        filePath = aDecoder.decodeObject(forKey: "BPModel_filePath") as! String?
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "BPModel_image")
        aCoder.encode(title, forKey: "BPModel_title")
        aCoder.encode(filePath, forKey: "BPModel_filePath")
    }
    
    override init() {
        super.init()
    }
    
    init(image: String, title: String, filePath: String) {
        self.image = image
        self.title = title
        self.filePath = filePath
    }
}
