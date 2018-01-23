//
//  BPNavigationController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/21.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class BPNavigationController: UINavigationController {

    private var rootVC: ViewController?
    
    override init(rootViewController: UIViewController) {
        rootVC = rootViewController as? ViewController
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootVC?.mainVC.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
