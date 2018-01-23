//
//  ViewController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/1/30.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

protocol BPPlayerDelegate {
    func bpPlayer(didSelectedToPlay path: String)
}

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, BPPlayerDelegate {

    public let mainVC = BPMainViewController()
    
    lazy var playButton = UIButton(type: .system)
    lazy var pathField = UITextField(frame: CGRect(x: 100, y: 160, width: 200, height: 44))
    let scroll = BPScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 400, height: 500), style: .plain)

    private var isFunctionListShow = false
    private var functionListConstraintTop: NSLayoutConstraint?
    
    private lazy var bpNavBar: BPNavigationBar? = {
        return BPNavigationBar.viewFromNib() as! BPNavigationBar
    }()
    private lazy var backView: UIView = {
        let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = UIColor.black
        aView.layer.opacity = 0.0
        
        return aView
    }()
    private lazy var visualEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        return visualEffect
    }()
    
    private lazy var functionListButton: UIButton = {
        return UIButton()
    }()
    
    private lazy var functionList: BPFunctionListView = {
        let arr = Bundle.main.loadNibNamed("BPFunctionListView", owner: nil, options: nil)
        return arr![0] as! BPFunctionListView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.transitionCoordinator?.animateAlongsideTransition(in: self.view, animation: { (content) in
//            self.backView.layer.opacity = 0.0
        }, completion: { (content) in
        })
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.transitionCoordinator?.animateAlongsideTransition(in: self.view, animation: { (content) in
//            self.backView.layer.opacity = 0.5
        }, completion: { (content) in
        })
        
        self.bpNavBar?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)

        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last ?? "")
        self.view.addSubview(functionList)
        
        self.navigationController?.delegate = self
        
        scroll.contentSize = CGSize(width: SCREEN_WIDTH*1, height: 0)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        scroll.bounces = false
        self.view.addSubview(scroll)
        
        self.view.addSubview(mainVC.view)
        self.addChildViewController(mainVC)
        mainVC.playerDelegate = self
        
        let webView: UIWebView = UIWebView()
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            webView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            webView.frame = CGRect(x: SCREEN_WIDTH/2 - 250, y: 0, width: 500, height: SCREEN_HEIGHT)
        }
        
        do {
            let str = try NSString(contentsOfFile: Bundle.main.path(forResource: "tutorial.html", ofType: nil)!, encoding: String.Encoding.utf8.rawValue)
            webView.loadHTMLString(str as String, baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
        } catch {
            
        }

        webView.scalesPageToFit = true
//        self.view.addSubview(webView)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.bpNavBar?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.bpNavBar!)
        
        let constraintTop = NSLayoutConstraint(item: (self.bpNavBar)!, attribute: .top, relatedBy: .equal, toItem: self.bpNavBar?.superview, attribute: .top, multiplier: 1, constant: 0)
        let constraintLeft = NSLayoutConstraint(item: (self.bpNavBar)!, attribute: .left, relatedBy: .equal, toItem: self.bpNavBar?.superview, attribute: .left, multiplier: 1, constant: 0)
        let constraintRight = NSLayoutConstraint(item: (self.bpNavBar)!, attribute: .right, relatedBy: .equal, toItem: self.bpNavBar?.superview, attribute: .right, multiplier: 1, constant: 0)
        let constraintHeight = NSLayoutConstraint(item: (self.bpNavBar)!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)
        
        self.bpNavBar?.addConstraints([constraintHeight])
        self.view.addConstraints([constraintTop, constraintLeft, constraintRight])
        
        
        bpNavBar?.titleLabel.text = "Yuki Player"
        bpNavBar?.backButton.isHidden = true
        bpNavBar?.leftButton.isHidden = true
        bpNavBar?.rightButton.isHidden = true
        
        
        functionListButton.addTarget(self, action: #selector(ViewController.functionListShow), for: .touchUpInside)
        functionListButton.setImage(UIImage(named: "functionList_Show.png"), for: .normal)
        functionListButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        functionListButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(functionListButton, at: 15)
        
        
        // Function list button
        let functionListButtonConstraintTop = NSLayoutConstraint(item: self.functionListButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 28)
        let functionListButtonConstraintRight = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.functionListButton, attribute: .trailing, multiplier: 1.0, constant: 8)
        let functionListButtonConstraintWidth = NSLayoutConstraint(item: self.functionListButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36)
        let functionListButtonConstraintHeight = NSLayoutConstraint(item: self.functionListButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        
        self.view.addConstraints([functionListButtonConstraintTop, functionListButtonConstraintRight])
        self.functionListButton.addConstraints([functionListButtonConstraintWidth, functionListButtonConstraintHeight])
        
        // Function list
        self.view.insertSubview(self.functionList, belowSubview: self.functionListButton)
        self.functionList.translatesAutoresizingMaskIntoConstraints = false
        
        self.functionList.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.functionList.layer.shadowColor = UIColor.black.cgColor
        self.functionList.layer.shadowOpacity = 0.05
        self.functionList.layer.shadowRadius = 10
        self.functionList.layer.cornerRadius = 12
        
        let functionListConstraintLeft = NSLayoutConstraint(item: self.functionList, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let functionListConstraintRight = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.functionList, attribute: .trailing, multiplier: 1.0, constant: 0)
        let functionListConstraintHeight = NSLayoutConstraint(item: self.functionList, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280)
        self.functionListConstraintTop = NSLayoutConstraint(item: self.functionList, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: -300)
        
        self.view.addConstraints([functionListConstraintLeft, functionListConstraintRight, functionListConstraintTop!])
        self.functionList.addConstraint(functionListConstraintHeight)
        
        self.functionList.linkToServer.addTarget(self, action: #selector(ViewController.linkToServer), for: .touchUpInside)
        self.functionList.settings.addTarget(self, action: #selector(ViewController.settings), for: .touchUpInside)
        
        // Visual Effect View
        self.view.insertSubview(visualEffect, belowSubview: functionList)
        self.visualEffect.translatesAutoresizingMaskIntoConstraints = false
        self.visualEffect.layer.opacity = 0
        
        let visualEffectConstraint = FFConstraint.fillScreen(item: visualEffect, toItem: self.view)
        self.view.addConstraints(visualEffectConstraint)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.visualEffectTap(gesture:)))
        self.visualEffect.addGestureRecognizer(tapGesture)
        
        // Back View
        self.view.insertSubview(self.backView, aboveSubview: self.functionListButton)
        self.view.addConstraints(FFConstraint.fillScreen(item: self.backView, toItem: self.view))
    }
    
    // MARK: - Function List
    @objc private func functionListShow() {
        
        let x: CGFloat = isFunctionListShow ? 0 : 1
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.functionListButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)*x)
            self.view.layoutIfNeeded()
            self.visualEffect.layer.opacity = Float(1)*Float(x)
        }) { (finished) in
        }
        
        isFunctionListShow ? functionListHideAnime() : functionListShowAnime()

        isFunctionListShow = !isFunctionListShow
    }
    
    private func functionListHideAnime() {
        
        let anime = CAKeyframeAnimation(keyPath: "position")
        anime.values = [CGPoint(x: UIScreen.main.bounds.size.width/2, y: 125), CGPoint(x: UIScreen.main.bounds.size.width/2, y: -175)]
        anime.duration = 0.3
        anime.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anime.fillMode = kCAFillModeForwards
        anime.isRemovedOnCompletion = false
        
        self.functionList.layer.add(anime, forKey: nil)
        self.functionListConstraintTop?.constant = -300
        self.functionList.layer.position = (self.functionList.layer.presentation()?.position)!
    }
    
    private func functionListShowAnime() {
        let anime = CAKeyframeAnimation(keyPath: "position")
        anime.values = [CGPoint(x: UIScreen.main.bounds.size.width/2, y: -140), CGPoint(x: UIScreen.main.bounds.size.width/2, y: 135), CGPoint(x: UIScreen.main.bounds.size.width/2, y: 125)]
        anime.duration = 0.5
        anime.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anime.fillMode = kCAFillModeForwards
        anime.isRemovedOnCompletion = false
        
        self.functionList.layer.add(anime, forKey: nil)
        self.functionListConstraintTop?.constant = -15
        self.functionList.layer.position = (self.functionList.layer.presentation()?.position)!
    }
    
    @objc private func visualEffectTap(gesture: UITapGestureRecognizer) {
        functionListShow()
    }
    
    @objc private func linkToServer() {
        let linkToServerVC = LinkToServerViewController()
        self.navigationController?.pushViewController(linkToServerVC, animated: true)
    }
    
    @objc private func settings() {
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "233"
        
        return cell
    }
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.isScrollEnabled = false
        if scrollView.contentOffset.x <= 0 {
            self.scroll.ges?.isEnabled = true
        } else if scrollView.contentOffset.x >= self.view.frame.size.width {
            self.scroll.ges?.isEnabled = false
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }

    // MARK: - UINavigationController Delegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        viewController.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            return .portrait
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            return [.landscapeLeft, .landscapeRight]
        }
        
        return .portrait
    }

    override var shouldAutorotate: Bool {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            return false
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            return true
        }
        
        return false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        var _flag = flag
        if viewControllerToPresent is BPAlertController {
            _flag = false
        }
        super.present(viewControllerToPresent, animated: _flag, completion: completion)
    }
    
    // MARK: - BPPlayer Delegate
    
    func bpPlayer(didSelectedToPlay path: String) {
        let window = UIApplication.shared.keyWindow
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            window?.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.backView.layer.opacity = 1
        }) { (finished) in
            window?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            let playViewController = BPPlayerViewController(filePath: path)
            self.present(playViewController, animated: false, completion: nil)
            
            let delay = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: delay) {
                
                self.backView.layer.opacity = 0
            }
        }
    }
    
    func play(sender: UIButton) {
        
        let testVC = BPPlayerViewController(filePath: "http://192.168.31.57:8000/video/1.mkv")
        self.present(testVC, animated: true, completion: nil)
        
     }
}

