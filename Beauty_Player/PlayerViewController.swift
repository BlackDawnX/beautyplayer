//
//  TestViewController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/1/30.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit


class PlayerViewController: UIViewController, VMediaPlayerDelegate {

    lazy var _playerView: UIView = {
        let SCREEN_SIZE_WIDTH = UIScreen.main.bounds.size.width
        let SCREEN_SIZE_HEIGHT = UIScreen.main.bounds.size.height
        return UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE_HEIGHT, height: SCREEN_SIZE_WIDTH))
    }()
    
    var isHUDHide = false
    
    var _player:VMediaPlayer = VMediaPlayer.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        _playerView.backgroundColor = UIColor.black
        _playerView.layer.masksToBounds = true
        self.view.addSubview(_playerView)
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        print(path)
        
        let localPath = "\(path!)/1.mkv"
        let localPath2 = "http://127.0.0.1:8000/video/1.mkv"
        let localPath3 = "http://192.168.31.57:8000/video/2.mov"
        let networkPath = "http://blackdawnx.cn/9.mp4"
        
        _player.setupPlayer(withCarrierView: _playerView, with: self)
        _player.setDataSource(URL(string: localPath3))
        _player.prepareAsync()
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isHUDHide = !isHUDHide
        
        UIView.animate(withDuration: 0.2) { 
            let scale: CGFloat = self.isHUDHide ? 1 : 0.7
            let size = UIScreen.main.bounds.size
            
            self._playerView.frame = CGRect(x: size.width/2 - size.width*scale/2, y: size.height/2 - size.height*scale/2, width: size.width*scale, height: size.height*scale)
            
            let cornerRadiusLevel: CGFloat = self.isHUDHide ? 0 : 1
            self._playerView.layer.cornerRadius = 10*cornerRadiusLevel
        }
    }

    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - VMediaPlayer Delegate
    
    func mediaPlayer(_ player: VMediaPlayer!, didPrepared arg: Any!) {
        player.start()
    }
    func mediaPlayer(_ player: VMediaPlayer!, playbackComplete arg: Any!) {
        
    }
    func mediaPlayer(_ player: VMediaPlayer!, error arg: Any!) {
        
    }

    
}
