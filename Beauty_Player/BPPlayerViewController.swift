//
//  ArPlayerViewController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/1/31.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class BPPlayerViewController: UIViewController, VMediaPlayerDelegate {
    
    // MARK: - Interface Builder Outlet
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var systemVolumControllerView: UIView!
    @IBOutlet weak var brightnessControllerView: UIView!
    
    private lazy var _playerView: UIView = {
        let SCREEN_SIZE_WIDTH = UIScreen.main.bounds.size.width
        let SCREEN_SIZE_HEIGHT = UIScreen.main.bounds.size.height

        if BPPlayerViewController.isUserInterfaceIdiomPhone() {
            return UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE_HEIGHT, height: SCREEN_SIZE_WIDTH))
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE_WIDTH, height: SCREEN_SIZE_HEIGHT))
        }
    }()
//    private lazy var _playerView: UIView = {
//        let SCREEN_SIZE_WIDTH = UIScreen.main.bounds.size.width
//        let SCREEN_SIZE_HEIGHT = UIScreen.main.bounds.size.height
//        
//        if BPPlayerViewController.isUserInterfaceIdiomPhone() {
//            return UIView()
//        } else {
//            return UIView()
//        }
//    }()
    
    var playerViewConstraintTop: NSLayoutConstraint?
    var playerViewConstraintLeft: NSLayoutConstraint?
    var playerViewConstraintRight: NSLayoutConstraint?
    var playerViewConstraintBottom: NSLayoutConstraint?
    var playerViewShadowConstraintTop: NSLayoutConstraint?
    var playerViewShadowConstraintLeft: NSLayoutConstraint?
    var playerViewShadowConstraintRight: NSLayoutConstraint?
    var playerViewShadowConstraintBottom: NSLayoutConstraint?
    
    private lazy var shadowView: UIView = {
        let SCREEN_SIZE_WIDTH = UIScreen.main.bounds.size.width
        let SCREEN_SIZE_HEIGHT = UIScreen.main.bounds.size.height

        if BPPlayerViewController.isUserInterfaceIdiomPhone() {
            return UIView()
        } else {
            return UIView()
        }
    }()
    
    private lazy var fastPlaybackHUD: FastPlaybackHUD = {
        let SCREEN_SIZE_WIDTH = UIScreen.main.bounds.size.width
        let SCREEN_SIZE_HEIGHT = UIScreen.main.bounds.size.height
        
        if BPPlayerViewController.isUserInterfaceIdiomPhone() {
            return FastPlaybackHUD(frame: CGRect(x: SCREEN_SIZE_HEIGHT/2 - 75, y: SCREEN_SIZE_WIDTH/2 - 75, width: 150, height: 150))
        } else {
            return FastPlaybackHUD(frame: CGRect(x: SCREEN_SIZE_WIDTH/2 - 150, y: SCREEN_SIZE_HEIGHT/2 - 150, width: 300, height: 300))
        }
    }()
    
    private var systemVolumController: SystemVolumController?
    private var screenBrightnessController: ScreenBrightnessController?
    
    public var _player: VMediaPlayer? = VMediaPlayer()
    private var isHUDHide = true
    private var time: Timer?
    private var _filePath: String
    
    public var filePath: String {
        get{
            return _filePath
        }
    }
    
    init(filePath: String) {
        _filePath = filePath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(BPPlayerViewController.pan(gesture:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BPPlayerViewController.tap(gesture:)))
        self._playerView.addGestureRecognizer(panGesture)
        self._playerView.addGestureRecognizer(tapGesture)
        
        setUpPlayer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    var tempPosition = 0
    var position: Int = 0
    
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            tempPosition = Int((_player?.getCurrentPosition())!)
            if !(_player?.isPlaying())! {
                _player?.start()
                playButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
            }
            fastPlaybackHUD.show()
            break
        case .changed:
            let translationX = gesture.translation(in: _playerView).x
            position = Int(translationX)*100 + tempPosition
            
            _player?.seek(to: position)
            progressSlider.setValue(Float(position), animated: false)
            
            if translationX >= 0 {
                fastPlaybackHUD.state = .forward
            } else if translationX < 0 {
                fastPlaybackHUD.state = .backward
            }
            
            break
        case .ended:
            _player?.seek(to: position)
            progressSlider.setValue(Float(position), animated: false)
            
            tempPosition = 0
            position = 0
            
            fastPlaybackHUD.hide(timeInterval: 1)
            
            break
        default:
            break
        }
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        scaleHUDView()
    }

    
    private func setUpPlayer() {
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        print(path ?? "nil")
        
//        let localPath = "\(path!)/1.mkv"
//        let localPath2 = "http://127.0.0.1:8000/video/1.mkv"
//        let localPath3 = "http://192.168.31.57:8000/video/1.mkv"
//        let networkPath = "http://blackdawnx.cn/9.mp4"
//        let livePath = "http://pull-g.kktv8.com/livekktv/100987038.flv"
        
        let decodingType = DencodeType(rawValue: UserDefaults.standard.integer(forKey: "DecodeType"))

        _player?.setupPlayer(withCarrierView: _playerView, with: self)
        _player?.setDataSource(URL(string: _filePath))
        _player?.prepareAsync()
        
        switch decodingType! {
        case .Hardware:
            _player?.decodingSchemeHint = VMDecodingSchemeHardware
            break
        case .Software:
            _player?.decodingSchemeHint = VMDecodingSchemeSoftware
            break
        case .QuickTime:
            _player?.decodingSchemeHint = VMDecodingSchemeQuickTime
            break
        }
        
        progressSlider.isContinuous = true
        progressSlider.minimumTrackTintColor = UIColor.black
        progressSlider.maximumTrackTintColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        progressSlider.thumbTintColor = UIColor.black
        
        systemVolumController = SystemVolumController(frame: CGRect(x: 0, y: 0, width: self.systemVolumControllerView.frame.size.width, height: self.systemVolumControllerView.frame.size.height))
        self.systemVolumControllerView.addSubview(systemVolumController!)
        self.systemVolumControllerView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))

        screenBrightnessController = ScreenBrightnessController(frame: CGRect(x: 0, y: 0, width: self.brightnessControllerView.frame.size.width, height: self.brightnessControllerView.frame.size.height))
        self.brightnessControllerView.addSubview(screenBrightnessController!)
        self.brightnessControllerView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))

        shadowView.backgroundColor = UIColor.black
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 10
        shadowView.layer.cornerRadius = 12
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        _playerView.backgroundColor = UIColor.black
        _playerView.layer.masksToBounds = true
        _playerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(shadowView)
        self.view.addSubview(_playerView)
        self.view.insertSubview(fastPlaybackHUD, at: 10)
        
        
        self.playerViewConstraintTop = NSLayoutConstraint(item: _playerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        self.playerViewConstraintLeft = NSLayoutConstraint(item: _playerView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        self.playerViewConstraintRight = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: _playerView, attribute: .trailing, multiplier: 1, constant: 0)
        self.playerViewConstraintBottom = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: _playerView, attribute: .bottom, multiplier: 1, constant: 0)

        self.playerViewShadowConstraintTop = NSLayoutConstraint(item: shadowView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        self.playerViewShadowConstraintLeft = NSLayoutConstraint(item: shadowView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        self.playerViewShadowConstraintRight = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: shadowView, attribute: .trailing, multiplier: 1, constant: 0)
        self.playerViewShadowConstraintBottom = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: shadowView, attribute: .bottom, multiplier: 1, constant: 0)

        self.view.addConstraints([playerViewConstraintTop!, playerViewConstraintLeft!, playerViewConstraintRight!, playerViewConstraintBottom!])
        self.view.addConstraints([playerViewShadowConstraintTop!, playerViewShadowConstraintLeft!, playerViewShadowConstraintRight!, playerViewShadowConstraintBottom!])

    }
    
    class func isUserInterfaceIdiomPhone() -> Bool {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Interface Builder Action
    
    @IBAction func back(_ sender: UIButton) {
        time?.invalidate()
        time = nil
        _player?.reset()
        if (_player?.unSetupPlayer())! {
            _player = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func progressSliderChanged(_ sender: UISlider) {
        _player?.seek(to: Int(sender.value))
        if !(_player?.isPlaying())! {
            _player?.start()
            playButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
        }
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        if (_player?.isPlaying())! {
            _player?.pause()
            sender.setImage(UIImage(named: "playButton.png"), for: .normal)
        } else {
            _player?.start()
            sender.setImage(UIImage(named: "pauseButton.png"), for: .normal)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    private func scaleHUDView() {
        isHUDHide = !isHUDHide
        
        let scale: CGFloat = self.isHUDHide ? 0 : 0.15
        let cornerRadiusLevel: CGFloat = self.isHUDHide ? 0 : 1
        let size = UIScreen.main.bounds.size
        
        self.playerViewConstraintTop?.constant = size.height*scale
        self.playerViewConstraintBottom?.constant = size.height*scale
        self.playerViewConstraintLeft?.constant = size.width*scale
        self.playerViewConstraintRight?.constant = size.width*scale
        
        self.playerViewShadowConstraintTop?.constant = size.height*scale
        self.playerViewShadowConstraintBottom?.constant = size.height*scale
        self.playerViewShadowConstraintLeft?.constant = size.width*scale
        self.playerViewShadowConstraintRight?.constant = size.width*scale
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self._playerView.layer.cornerRadius = 12*cornerRadiusLevel
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - VMediaPlayer Delegate
    
    func mediaPlayer(_ player: VMediaPlayer!, didPrepared arg: Any!) {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last

//        _player?.setSubTrackWithPath("\(path!)/005.srt")
        _player?.addSubTrackToArray(withPath: "\(path!)/005.srt")
        _player?.setSubShown(true)
        player.start()
        
        self.progressSlider.minimumValue = 0
        self.progressSlider.maximumValue = Float(player.getDuration())
        self.progressSlider.value = 0
        
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BPPlayerViewController.updateProgressSliderValue), userInfo: nil, repeats: true)
        RunLoop.main.add(time!, forMode: .commonModes)
        time!.fire()
        
    }
    
    func mediaPlayer(_ player: VMediaPlayer!, playbackComplete arg: Any!) {
        time?.invalidate()
        time = nil
        _player?.reset()
        if (_player?.unSetupPlayer())! {
            _player = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mediaPlayer(_ player: VMediaPlayer!, error arg: Any!) {
        
    }
    
    func mediaPlayer(_ player: VMediaPlayer!, seekComplete arg: Any!) {
        print("\(player.getCurrentPosition())")
    }

    func updateProgressSliderValue() {
        (_player?.getDuration())! != (_player?.getCurrentPosition())! ? (self.progressSlider.value = Float((_player?.getCurrentPosition())!)) : (self.progressSlider.value = Float((_player?.getDuration())!))
    }
    
    class func isExtensionSupport(ext: String) -> Bool {
        if ext == "mp4" || ext == "m4v" || ext == "mp3" || ext == "mkv" || ext == "rmvb" || ext == "xvid" || ext == "vp6" || ext == "avi" || ext == "flv" || ext == "mov" {
//            return true
        }
        
        let path = Bundle.main.path(forResource: "supportedExt.plist", ofType: nil)
        let arr = NSArray(contentsOfFile: path!) as! [String]
        
        for i in arr {
            if i == ext {
                return true
            }
        }
        
        return false
    }
    
    deinit {
    }
}
