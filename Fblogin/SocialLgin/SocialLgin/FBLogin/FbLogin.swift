//
//  FbLogin.swift
//  SocialLgin
//
//  Created by Muhammed Salih on 01/01/16.
//  Copyright © 2016 Muhammed Salih T A. All rights reserved.
//
class FbLogin: NSObject {
    
    static func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
   static func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

}
