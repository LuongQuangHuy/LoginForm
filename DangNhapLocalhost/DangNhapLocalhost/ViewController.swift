//
//  ViewController.swift
//  DangNhapLocalhost
//
//  Created by Luong Quang Huy on 5/21/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit
import Kingfisher
class ViewController: UIViewController {
    var result: UserModel?
    enum LoginError: Error{
        case EmailFormatIsInvalid
        case PasswordFormatIsInvalid
        case InvalidEmail
        case InvalidPassword
    }

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubView()
    }

    func layoutSubView(){
        //layout Button
        loginButton.tintColor = UIColor.white
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 12.0
        //layout Background
        let backgroundImageURL = URL(string: "https://cdn.statically.io/img/r1.ilikewallpaper.net/iphone-11-wallpapers/download/79962/Laguna-Beach-iphone-11-wallpaper-ilikewallpaper_com.jpg")
        if let url = backgroundImageURL{
            self.backgroundImage.kf.setImage(with: url)
        }
    }
    
    
    func tryLogin(){
        let myUrl = URL(string: "localhost:3000/login")
        guard let url = myUrl else{
            defer {
                var alert = CustomAlert()
                alert.vcDelegate = self
                alert.createAndImplementAlert(title: "URL error", message: "URL no exist", type: .Invalid)
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let postJsonBody = """
        {
        "email": "\(self.txtEmail.text!)",
        "password": "\(self.txtPassword.text!)"
        }
        """
        
        let postData = postJsonBody.data(using: .utf8)
        
        let uploadTask = URLSession.shared.uploadTask(with: urlRequest, from: postData) { [weak self](data, response, error) in
            if let requestError = error{
                defer{
                    DispatchQueue.main.async {
                        var alert = CustomAlert()
                        alert.vcDelegate = self
                        alert.createAndImplementAlert(title: "REQUEST ERROR", message: "An Error occur while make request", type: .Invalid)
                    }
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse , let data = data else {
                defer{
                    DispatchQueue.main.async {
                        var alert = CustomAlert()
                        alert.vcDelegate = self
                        alert.createAndImplementAlert(title: "REQUEST ERROR", message: "Has no response", type: .Invalid)
                    }
                }
                return
            }
            
            if (200...299).contains(response.statusCode){
                do{
                    self?.result = try JSONDecoder().decode(UserModel.self, from: data)
                    DispatchQueue.main.async {
                        var alert = CustomAlert()
                        alert.vcDelegate = self
                        alert.createAndImplementAlert(title: "LOGIN SUCCESS", message: "Status code: \(response.statusCode)", type: .Valid)
                        alert.submitAction = {
                            [weak self](_) -> Void in
                            var view2 = ViewController2()
                            view2.setUpdataDelegate = self
                            self?.present(view2, animated: true, completion: nil)
                        }
                    }
                }catch{
                    defer{
                        DispatchQueue.main.async {
                            var alert = CustomAlert()
                            alert.vcDelegate = self
                            alert.createAndImplementAlert(title: "DECODE ERROR", message: "\(error.localizedDescription)", type: .Invalid)
                        }
                    }
                    return
                }
            }else{
                defer{
                    DispatchQueue.main.async {
                        var alert = CustomAlert()
                        alert.vcDelegate = self
                        alert.createAndImplementAlert(title: "BAD REQUEST", message: "Status code: \(response.statusCode)", type: .Invalid)
                    }
                }
                return
                
            }
        }
        uploadTask.resume()
            
    }
    
    func validateInfo() throws{
        
        if let emailText = self.txtEmail.text{
            if emailText.isEmpty{
                throw LoginError.InvalidEmail
            }else if emailText.isValidEmail == false{
                throw LoginError.EmailFormatIsInvalid
            }else if let passwordText = self.txtPassword.text{
                if passwordText.isEmpty{
                    throw LoginError.InvalidPassword
                }
            }else{
                throw LoginError.InvalidPassword
            }
        }else{
            throw LoginError.InvalidEmail
        }
    }
    
    func login(){
        do{
            try validateInfo()
            tryLogin()
        }catch LoginError.InvalidEmail{
            var alert = CustomAlert()
            alert.vcDelegate = self
            alert.createAndImplementAlert(title: "Email invalid", message: "Chưa nhập Email", type: .Invalid)
            
        }catch LoginError.EmailFormatIsInvalid{
            var alert = CustomAlert()
            alert.vcDelegate = self
            alert.createAndImplementAlert(title: "Email invalid", message: "Email không đúng định dạng", type: .Invalid)
        }catch LoginError.InvalidPassword{
            var alert = CustomAlert()
            alert.vcDelegate = self
            alert.createAndImplementAlert(title: "Password invalid", message: "Chưa nhập Password", type: .Invalid)
        }catch LoginError.PasswordFormatIsInvalid{
            var alert = CustomAlert()
            alert.vcDelegate = self
            alert.createAndImplementAlert(title: "Password invalid", message: "Password không đúng định dạng", type: .Invalid)
        }catch{
            var alert = CustomAlert()
            alert.vcDelegate = self
            alert.createAndImplementAlert(title: "Reqest Error", message: "\(error.localizedDescription)", type: .Invalid)
        }
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        login()
    }
}

extension ViewController: PresentAlert{
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: SetUpDataDelegate{
    var data: UserModel?{
        get{
            return self.result
        }
    }
}
