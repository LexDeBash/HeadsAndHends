//
//  AuthorizationVC.swift
//  HeadsAndHends
//
//  Created by Alexey Efimov on 12.07.17.
//  Copyright © 2017 LDB. All rights reserved.
//

import UIKit

class AuthorizationVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }

}
