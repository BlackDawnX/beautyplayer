//
//  SettingsViewController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/3/4.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

enum DencodeType: Int {
    case Hardware = 0
    case Software = 1
    case QuickTime = 2
}

class SettingsViewController: UIViewController {

    private lazy var bpNavBar: BPNavigationBar? = {
        return BPNavigationBar.viewFromNib() as! BPNavigationBar
    }()
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<3 {
            let btn = UIButton(type: .system)
            if i == 0 {
                btn.setTitle("硬解", for: .normal)
            } else if i == 1 {
                btn.setTitle("软解", for: .normal)
            } else if i == 2 {
                btn.setTitle("Quick Time", for: .normal)
            }
            btn.tag = i
            btn.frame = CGRect(x: 100, y: 100*(i+1), width: 100, height: 44)
            btn.addTarget(self, action: #selector(SettingsViewController.decodeSelect(btn:)), for: .touchUpInside)
            
            self.view.addSubview(btn)
        }
        
        self.bpNavBar?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.bpNavBar!)
        
        let constraintHeight = NSLayoutConstraint(item: (self.bpNavBar)!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)
        
        self.bpNavBar?.addConstraints([constraintHeight])
        self.view.addConstraints(FFConstraint.topOffSet(item: (self.bpNavBar)!, toItem: self.view, top: 0))
        
        bpNavBar?.titleLabel.isHidden = false
        bpNavBar?.backButton.isHidden = false
        bpNavBar?.leftButton.isHidden = true
        bpNavBar?.rightButton.isHidden = true
        
        bpNavBar?.backButton.addTarget(self, action: #selector(SettingsViewController.back(btn:)), for: .touchUpInside)
        
        self.view.backgroundColor = THEME_COLOR
    }
    
    func decodeSelect(btn: UIButton) {
        switch btn.tag {
        case 0:
            userDefault.set(DencodeType.Hardware.rawValue, forKey: "DecodeType")
            break
        case 1:
            userDefault.set(DencodeType.Software.rawValue, forKey: "DecodeType")
            break
        case 2:
            userDefault.set(DencodeType.QuickTime.rawValue, forKey: "DecodeType")
            break
        default:
            break
        }
        
        userDefault.synchronize()
    }
    
    @objc private func back(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
