//
//  ViewController.swift
//  AppleSignButton
//
//  Created by Sandeep Kumar on 27/04/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var appleSignInBtn: AppleSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleSignInBtn.didCompletedSignIn = { (user) in
            print(user.id ?? "", user.email ?? "", user.firstName ?? "", user.lastName ?? "")
        }
    
    }
    
}

