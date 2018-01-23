//
//  SystemVolumController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/1/31.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit
import MediaPlayer

class SystemVolumController: UIView {

    public var slider: UISlider?
    
    private var airPlayButton: UIButton?
    private var volumView = MPVolumeView()
    private var volumViewSlider: UISlider?
    private var volumImage = UIImageView(frame: CGRect(x: -36, y: -10, width: 36, height: 36))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in volumView.subviews {
            if i is UISlider {
                slider = i as? UISlider
                slider?.thumbTintColor = UIColor.black
                slider?.minimumTrackTintColor = UIColor.black
                slider?.maximumTrackTintColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
                slider?.layer.shadowOpacity = 0
            }
            if i is UIButton {
                airPlayButton = i as? UIButton
                airPlayButton?.isHidden = true
            }
        }
        
        volumView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(volumView)
        
        volumImage.image = UIImage(named: "Volum.png")
        self.addSubview(volumImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
