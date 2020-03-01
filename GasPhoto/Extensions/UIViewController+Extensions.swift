//
//  UIViewController+Extensions.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-29.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//
import UIKit

extension  UIViewController {
    
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
