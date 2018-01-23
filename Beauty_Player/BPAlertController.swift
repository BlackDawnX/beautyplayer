//
//  BeautyAlertController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/7.
//  Copyright © 2017年 Aaron. All rights reserved.
//


import UIKit

public enum BeautyAlertButtonType {
    case Cancel
    case Confirm
    case Distruct
}

/**
 BPAlertController
 
 *Version 1.0.1*
 
 Usage:
 
 * *initialize*：
 ````
 let alert = BPAlertController(title: "Sample", content: "Sample content")
 ````

  * Add *action*(like `UIAlertController`)：
 ````
 alert.addAction(title: "One", type: .Confirm, handler: nil)
 ````
 
 * Also you can use *handler*:
 ````
 alert.addAction(title: "Two", type: .Confirm) {
    print("Handler statements")
 }
 ````
 
 * At last, you should present the controller from super view controller:
 ````
 present(alert, animated: true, completion: nil)
 ````
 
 */
class BPAlertController: UIViewController {

//    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    private var alertTitle = ""
    private var content = ""
//    private var alertView: UIView {
//        let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//        let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//        return UIView(frame: CGRect(x: SCREEN_WIDTH/2 - 300/2, y: SCREEN_HEIGHT/2 - 200/2, width: 300, height: 200))
//    }
    private var alertView = UIView(frame: CGRect(x: SCREEN_WIDTH/2 - 300/2, y: SCREEN_HEIGHT/2 - 200/2, width: 300, height: 200))
    private var actions: [[String: Any]] = []
    
    /// Deprecated
    private var leftHandler: (() -> Swift.Void)?
    private var rightHandler: (() -> Swift.Void)?
    
    init(title: String?, content: String?) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title ?? ""
        self.content = content ?? ""
        
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
            print("\(alertTitle), \(content)")
        #endif
        
        if !actions.isEmpty {
            if actions.count == 1 {
                let action = actions[0]
                
                let btn = UIButton(type: .system)
                btn.frame = CGRect(x: 0, y: 154, width: alertView.bounds.size.width, height: 46)
                btn.setTitle(action["title"] as? String, for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitleColor(UIColor.lightGray, for: .highlighted)
                btn.tag = 0
                btn.addTarget(self, action: #selector(BPAlertController.buttonClicked(_:)), for: .touchUpInside)
                
                switch action["type"] as! BeautyAlertButtonType {
                case .Cancel:
                    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    break
                case .Confirm:
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                    break
                case .Distruct:
                    btn.setTitleColor(UIColor.red, for: .normal)
                    break
                }
                
                self.alertView.addSubview(btn)

            } else if actions.count == 2 {
                
                for i in 0...1 {
                    let action = actions[i] 
                    
                    let btn = UIButton(type: .system)
                    btn.frame = CGRect(x: (alertView.bounds.size.width/2)*CGFloat(i), y: 154, width: alertView.bounds.size.width/2, height: 46)
                    btn.setTitle(action["title"] as? String, for: .normal)
                    btn.setTitleColor(UIColor.black, for: .normal)
                    btn.setTitleColor(UIColor.lightGray, for: .highlighted)
                    btn.tag = i
                    btn.addTarget(self, action: #selector(BPAlertController.buttonClicked(_:)), for: .touchUpInside)
                    
                    switch action["type"] as! BeautyAlertButtonType {
                    case .Cancel:
                        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                        break
                    case .Confirm:
                        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                        break
                    case .Distruct:
                        btn.setTitleColor(UIColor.red, for: .normal)
                        break
                    }
                    
                    self.alertView.addSubview(btn)
                }
                
            } else if actions.count > 2 {
                var alertViewHeight = self.alertView.bounds.size.height

                for i in 0...actions.count - 1 {
                    let action = actions[i]
                    
                    let btn = UIButton(type: .system)
                    btn.frame = CGRect(x: 0, y: 154.0 + (46*CGFloat(i)), width: alertView.bounds.size.width, height: 46)
                    btn.setTitle(action["title"] as? String, for: .normal)
                    btn.setTitleColor(UIColor.black, for: .normal)
                    btn.setTitleColor(UIColor.lightGray, for: .highlighted)
                    btn.tag = i
                    btn.addTarget(self, action: #selector(BPAlertController.buttonClicked(_:)), for: .touchUpInside)
                    
                    switch action["type"] as! BeautyAlertButtonType {
                    case .Cancel:
                        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                        break
                    case .Confirm:
                        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                        break
                    case .Distruct:
                        btn.setTitleColor(UIColor.red, for: .normal)
                        break
                    }
                    
                    self.alertView.addSubview(btn)
                    
                    alertViewHeight += 46
                }
                
                self.alertView.frame = CGRect(x: SCREEN_WIDTH/2 - 300/2, y: SCREEN_HEIGHT/2 - (alertViewHeight - 46)/2, width: 300, height: alertViewHeight - 46)
            }
        }
        
        alertView.backgroundColor = UIColor.white
        alertView.layer.opacity = 0.0
        alertView.layer.cornerRadius = 12.0
        alertView.layer.shadowOffset = CGSize(width: 0, height: 10)
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 0.3
        alertView.layer.shadowRadius = 10
        
        let titleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: alertView.bounds.size.width - 10, height: 44))
        titleLabel.text = alertTitle
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let contentLabel = UILabel(frame: CGRect(x: 5, y: 54, width: alertView.bounds.size.width - 10, height: 100))
        contentLabel.text = content
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        let line = UIImageView(image: UIImage(named: "line.png"))
        line.contentMode = .scaleToFill
        line.frame = CGRect(x: 0, y: 150, width: alertView.bounds.size.width, height: 3)
        line.layer.opacity = 0.1
        
        alertView.addSubview(line)
        alertView.addSubview(titleLabel)
        alertView.addSubview(contentLabel)
        

        self.show(view: alertView, animated: true)
    }
    
    open func addAction(title: String?,type: BeautyAlertButtonType, handler: (() -> Swift.Void)?) {
        let actionTitle = title ?? ""
        let actionType = type
        let actionHandler = handler
        
        let action = ["title": actionTitle,
                      "type": actionType,
                      "handler": actionHandler] as [String : Any]
        
        self.actions.append(action)
    }

    @objc private func buttonClicked(_ sender: UIButton) {
        
        if #available(iOS 10.0, *) {
            let feedBack = UIImpactFeedbackGenerator(style: .light)
            feedBack.impactOccurred()
        } else {
        }
        
        let action = actions[sender.tag]
        let handler = action["handler"] as? () -> Swift.Void
        if handler?() != nil {
        }
        for i in self.alertView.subviews {
            i.isUserInteractionEnabled = false
        }
        
        dismissAlertController()
    }
    
    private func dismissAlertController() {
        let animateDuration = 0.2
        
        let animation01 = CABasicAnimation()
        animation01.keyPath = "opacity"
        animation01.fromValue = 1
        animation01.toValue = 0
        animation01.duration = animateDuration
        animation01.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation01.fillMode = kCAFillModeForwards
        animation01.isRemovedOnCompletion = false
        
        let animation02 = CABasicAnimation()
        animation02.keyPath = "transform.scale"
        animation02.fromValue = 1
        animation02.toValue = 0.7
        animation02.duration = animateDuration
        animation02.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation02.fillMode = kCAFillModeRemoved
        animation02.isRemovedOnCompletion = false
        
        self.alertView.layer.add(animation01, forKey: nil)
        self.alertView.layer.add(animation02, forKey: nil)
        
        let delay = DispatchTime.now() + animateDuration
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @available(*, deprecated, message: "Not recommended in version 1.0.1 or newer version.", renamed: "addAction(title:type:handler:)")
    open func leftButton(title: String?, type: BeautyAlertButtonType, handler: (() -> Swift.Void)?) {
        
        let leftButton = UIButton(type: .system)
        leftButton.frame = CGRect(x: 0, y: 154, width: alertView.bounds.size.width/2, height: 46)
        leftButton.setTitle(title ?? "Left", for: .normal)
        leftButton.setTitleColor(UIColor.black, for: .normal)
        leftButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        leftButton.addTarget(self, action: #selector(BPAlertController.leftButtonClicked(sender:)), for: .touchUpInside)
        
        self.leftHandler = handler
        
        switch type {
        case .Cancel:
            leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            break
        case .Confirm:
            leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            break
        case .Distruct:
            leftButton.setTitleColor(UIColor.red, for: .normal)
            break
        }
        
        self.alertView.addSubview(leftButton)
    }
    
    @available(*, deprecated, message: "Not recommended in version 1.0.1 or newer version.", renamed: "addAction(title:type:handler:)")
    open func rightButton(title: String?, type: BeautyAlertButtonType, handler: (() -> Swift.Void)?) {
        
        let rightButton = UIButton(type: .system)
        rightButton.frame = CGRect(x: alertView.bounds.size.width/2, y: 154, width: alertView.bounds.size.width/2, height: 46)
        rightButton.setTitle(title ?? "Right", for: .normal)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        rightButton.addTarget(self, action: #selector(BPAlertController.rightButtonClicked(sender:)), for: .touchUpInside)
        
        self.rightHandler = handler
        
        switch type {
        case .Cancel:
            rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            break
        case .Confirm:
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            break
        case .Distruct:
            rightButton.setTitleColor(UIColor.red, for: .normal)
            break
        }
        
        self.alertView.addSubview(rightButton)
    }
    
    
    private func show(view: UIView, animated: Bool) {
        let background = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        background.backgroundColor = UIColor.black
        background.layer.opacity = 0.1
        background.isUserInteractionEnabled = false
        
        self.view.addSubview(background)
        self.view.addSubview(view)
        
        if animated {
            
            let animateDuration = 0.2
            
            let animation01 = CABasicAnimation()
            animation01.keyPath = "opacity"
            animation01.fromValue = 0
            animation01.toValue = 1
            animation01.duration = animateDuration
            animation01.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation01.fillMode = kCAFillModeForwards
            animation01.isRemovedOnCompletion = false
            
            let animation02 = CABasicAnimation()
            animation02.keyPath = "transform.scale"
            animation02.fromValue = 1.3
            animation02.toValue = 1
            animation02.duration = animateDuration
            animation02.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation02.fillMode = kCAFillModeRemoved
            animation02.isRemovedOnCompletion = false
            
            view.layer.add(animation01, forKey: nil)
            view.layer.add(animation02, forKey: nil)
            
            let delay = DispatchTime.now() + animateDuration
            DispatchQueue.main.asyncAfter(deadline: delay) {
                view.layer.opacity = 1
            }
            
        } else {
            view.layer.opacity = 1.0
        }
    }
    
    @objc private func leftButtonClicked(sender: UIButton) {
        
        if self.leftHandler != nil {
            self.leftHandler!()
        }
        
        let animateDuration = 0.2

        let animation01 = CABasicAnimation()
        animation01.keyPath = "opacity"
        animation01.fromValue = 1
        animation01.toValue = 0
        animation01.duration = animateDuration
        animation01.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation01.fillMode = kCAFillModeForwards
        animation01.isRemovedOnCompletion = false
        
        let animation02 = CABasicAnimation()
        animation02.keyPath = "transform.scale"
        animation02.fromValue = 1
        animation02.toValue = 0.7
        animation02.duration = animateDuration
        animation02.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation02.fillMode = kCAFillModeRemoved
        animation02.isRemovedOnCompletion = false
        
        self.alertView.layer.add(animation01, forKey: nil)
        self.alertView.layer.add(animation02, forKey: nil)
        
        let delay = DispatchTime.now() + animateDuration
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc private func rightButtonClicked(sender: UIButton) {
        
        if self.rightHandler != nil {
            self.rightHandler!()
        }
        
        let animateDuration = 0.2
        
        let animation01 = CABasicAnimation()
        animation01.keyPath = "opacity"
        animation01.fromValue = 1
        animation01.toValue = 0
        animation01.duration = animateDuration
        animation01.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation01.fillMode = kCAFillModeForwards
        animation01.isRemovedOnCompletion = false
        
        let animation02 = CABasicAnimation()
        animation02.keyPath = "transform.scale"
        animation02.fromValue = 1
        animation02.toValue = 0.7
        animation02.duration = animateDuration
        animation02.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation02.fillMode = kCAFillModeRemoved
        animation02.isRemovedOnCompletion = false
        
        self.alertView.layer.add(animation01, forKey: nil)
        self.alertView.layer.add(animation02, forKey: nil)
        
        let delay = DispatchTime.now() + animateDuration
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    open func getAlertTitle() -> String {
        return self.alertTitle
    }
    
    open func getAlertContent() -> String {
        return self.content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



