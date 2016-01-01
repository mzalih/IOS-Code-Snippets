//
//  ViewController.swift
//  SocialLgin
//
//  Created by Muhammed Salih on 01/01/16.
//  Copyright © 2016 Muhammed Salih T A. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FBLoginDelegate {
    //var loginView : FBSDKLoginButton?
    @IBAction func button(sender: AnyObject) {
        FbLogin.logIn(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //IS THE DELEGATE
    func onFbLoggedIn(status: Bool) {
        FbLogin.returnUserData()
    }
}

