//
//  ScreenBrightnessController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/12.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class ScreenBrightnessController: UIView {
    
    var slider: UISlider
    
    override init(frame: CGRect) {
        
        slider = UISlider(frame: CGRect(x: 0, y: 0, width: frame.size.width - 28.5, height: frame.size.height))
        
        super.init(frame: frame)
        
        slider.thumbTintColor = UIColor.black
        slider.minimumTrackTintColor = UIColor.black
        slider.maximumTrackTintColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        slider.layer.shadowOpacity = 0
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(ScreenBrightnessController.sliderValueChanged), for: .valueChanged)
        
        slider.value = Float(UIScreen.main.brightness)
        
        let brightnessImageView = UIImageView(frame: CGRect(x: -36, y: 0, width: 36, height: 36))
        brightnessImageView.image = UIImage(named: "brightnessImage.png")
        
        self.addSubview(slider)
        self.addSubview(brightnessImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func sliderValueChanged() {
        UIScreen.main.brightness = CGFloat(slider.value)
    }
}
