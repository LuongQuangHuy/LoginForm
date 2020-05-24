//
//  Extension.swift
//  DangNhapLocalhost
//
//  Created by Luong Quang Huy on 5/21/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation


extension String{
    var isValidEmail: Bool{
        let stringFormat = "[A-Z0-9a-z+-._%]+@[A-Z0-9a-z]+\\.[A-Za-z]{3}"
        let emailFormat = NSPredicate(format:"SELF MATCHES %@", stringFormat)
        return emailFormat.evaluate(with: self)
    }
}
