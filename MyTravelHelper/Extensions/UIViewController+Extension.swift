//
//  UIViewController+Extension.swift
//  MyTravelHelper
//
//  Created by Jaswanth Pereira on 24/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertMessage(_ message: String) {
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(ok)
        present(alertViewController, animated: true, completion: nil)
    }
}
