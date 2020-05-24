//
//  CustomAlertVCTool.swift
//  CheckingNumber
//
//  Created by Luong Quang Huy on 5/20/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation
import UIKit

protocol PresentAlert{
    func showAlert(alert: UIAlertController)
}

struct CustomAlert{
    enum AlertType{
        case Valid
        case Invalid
    }
    var submitAction: ((UIAlertAction) -> Void)?
    var cancelAction: ((UIAlertAction) -> Void)?
    var vcDelegate: PresentAlert?
    func createAndImplementAlert(title: String, message: String , type: AlertType){
        switch type {
            
        case .Valid:
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: submitAction)
            alertController.addAction(alertAction)
            vcDelegate?.showAlert(alert: alertController)
        case .Invalid:
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
            alertController.addAction(alertAction)
            vcDelegate?.showAlert(alert: alertController)
       
        }
    }
}
