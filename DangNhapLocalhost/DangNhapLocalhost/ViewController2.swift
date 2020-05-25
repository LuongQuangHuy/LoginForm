//
//  ViewController2.swift
//  DangNhapLocalhost
//
//  Created by Luong Quang Huy on 5/21/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

protocol SetUpDataDelegate: AnyObject{
    var data: UserModel?{get}
}

class ViewController2: UIViewController {
    weak var setUpdataDelegate: SetUpDataDelegate?
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthDay: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubView()
        setUpInfomation()
    }
    
    func layoutSubView(){
        // set Background image
        let backgroundImageURL = URL(string: "https://iphonewallpaper.pro/wp-content/uploads/2020/03/iphone-11-wallpaper-hd-828x1792px-1.jpg")
        if let url = backgroundImageURL{
            backgroundImage.kf.setImage(with: url)
        }
        avatar.layer.cornerRadius = 20.0
        avatar.backgroundColor = .lightGray
        
    }
    
    func setUpInfomation(){
        guard let data = self.setUpdataDelegate?.data else {return}
        self.name.text = data.name
        self.birthDay.text = data.birthDay
        self.gender.text = data.gender
        self.phoneNumber.text = data.phone
        if let avatarURL = URL(string: data.avartar){
            self.avatar.kf.setImage(with: avatarURL)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInfomation()
    }

    
    @IBAction func edditButtonTapped(_ sender: Any) {
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
