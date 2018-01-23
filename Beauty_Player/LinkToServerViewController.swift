//
//  LinkToServerViewController.swift
//  Beauty_Player
//
//  Created by Aaron on 2017/2/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

import UIKit

class LinkToServerViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    private lazy var bpNavBar: BPNavigationBar? = {
        return BPNavigationBar.viewFromNib() as! BPNavigationBar
    }()
    
    private lazy var urlField: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        field.placeholder = NSLocalizedString("UrlHere", comment: "")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        return field
    }()
    
    private lazy var urlFieldView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.white
        aView.translatesAutoresizingMaskIntoConstraints = false
        return aView
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Play", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var blackView: UIView = {
        let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = UIColor.black
        aView.layer.opacity = 0
        return aView
    }()
    
    private lazy var historyList: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = THEME_COLOR
        tableView.separatorStyle = .none
        return tableView
    }()
//    private var historyArr: 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bpNavBar?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.bpNavBar!)
        
        let constraintHeight = NSLayoutConstraint(item: (self.bpNavBar)!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)
        
        self.bpNavBar?.addConstraints([constraintHeight])
        self.view.addConstraints(FFConstraint.topOffSet(item: (self.bpNavBar)!, toItem: self.view, top: 0))
        
        bpNavBar?.titleLabel.isHidden = false
        bpNavBar?.backButton.isHidden = false
        bpNavBar?.leftButton.isHidden = true
        bpNavBar?.rightButton.isHidden = true

        bpNavBar?.backButton.addTarget(self, action: #selector(LinkToServerViewController.back(btn:)), for: .touchUpInside)
        bpNavBar?.titleLabel.text = NSLocalizedString("LinkToServer", comment: "")
        
        self.view.backgroundColor = THEME_COLOR
        
        // URL Field
        urlField.delegate = self
        
        self.view.addSubview(self.urlFieldView)
        self.view.addConstraints(FFConstraint.topOffSet(item: self.urlFieldView, toItem: self.view, top: 64))
        
        let urlFieldViewHeight = NSLayoutConstraint(item: self.urlFieldView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        self.urlFieldView.addConstraint(urlFieldViewHeight)
        
        self.urlFieldView.addSubview(urlField)
        
        let urlFieldCenter = FFConstraint.centerScreenOffSet(item: self.urlField, toItem: self.urlFieldView, x: 0, y: 0)
        
        let urlFieldLeading = NSLayoutConstraint(item: self.urlField, attribute: .leading, relatedBy: .equal, toItem: self.urlFieldView, attribute: .leading, multiplier: 1.0, constant: 20)
        let urlFieldTrailing = NSLayoutConstraint(item: self.urlFieldView, attribute: .trailing, relatedBy: .equal, toItem: self.urlField, attribute: .trailing, multiplier: 1.0, constant: 20)
        
        self.urlFieldView.addConstraints(urlFieldCenter)
        self.urlFieldView.addConstraints([urlFieldLeading, urlFieldTrailing])
        
        // Play Button
//        self.view.addSubview(playButton)
//        playButton.addConstraints(BPConstraint.size(width: 100, height: 44, item: self.playButton))
//        self.view.addConstraints(BPConstraint.centerScreen(item: self.playButton, toItem: self.view))
        
        playButton.addTarget(self, action: #selector(LinkToServerViewController.play(btn:)), for: .touchUpInside)
        
        // History List
        historyList.delegate = self
        historyList.dataSource = self
        
        self.view.addSubview(historyList)
        
        self.view.addConstraints(FFConstraint.fillOffSet(item: self.historyList, toItem: self.view, topOffSet: 108, bottomOffSet: 0, leadingOffSet: 0, trailingOffSet: 0))
        
        // Black View
        self.view.insertSubview(blackView, at: 10)
        self.view.addConstraints(FFConstraint.fillScreen(item: self.blackView, toItem: self.view))
    }

    @objc private func back(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func play(btn: UIButton) {
        let window = UIApplication.shared.keyWindow
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            window?.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.blackView.layer.opacity = 1
        }) { (finished) in
            window?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            let playViewController = BPPlayerViewController(filePath: "http://192.168.2.1:8000/video/1.mkv")
            self.present(playViewController, animated: false, completion: nil)
            
            let delay = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: delay) {
            
                self.blackView.layer.opacity = 0
            }
        }
    }
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITableView Delegate & Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "historyListCell")
        cell.backgroundColor = THEME_COLOR
        cell.selectionStyle = .none
        cell.textLabel?.text = "123"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
