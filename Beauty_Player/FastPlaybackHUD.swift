//
//  fastPlaybackHUD.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/12.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

enum FastPlaybackState {
    case forward
    case backward
}

class FastPlaybackHUD: UIView {

    public var state: FastPlaybackState {
        set {
            _state = newValue
            fastPlaybackStateChange(state: newValue)
        }
        get {
            return _state ?? .forward
        }
    }
    
    private var _state: FastPlaybackState?
    private lazy var stateImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stateImage.frame = CGRect(x: frame.size.width/2 - 40, y: frame.size.height/2 - 40, width: 80, height: 80)
        stateImage.image = UIImage(named: "fastPlayback.png")
        
        self.addSubview(stateImage)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        
        self.hide()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show() {
        self.layer.opacity = 1
    }
    
    public func hide() {
        self.layer.opacity = 0
    }
    
    public func hide(timeInterval: TimeInterval) {
        UIView.animate(withDuration: timeInterval) {
            self.layer.opacity = 0
        }
    }
    
    private func fastPlaybackStateChange(state: FastPlaybackState) {
        switch state {
        case .forward:
            stateImage.image = UIImage(named: "fastPlayback.png")
            break
        case .backward:
            stateImage.image = UIImage(named: "fastPlayback_backward.png")
            break
        }
    }
}
