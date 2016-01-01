//
//  FbLogin.swift
//  SocialLgin
//
//  Created by Muhammed Salih on 01/01/16.
//  Copyright © 2016 Muhammed Salih T A. All rights reserved.
//
protocol FBLoginDelegate{
    func onFbLoggedIn(status:Bool)
}
class FbLogin:NSObject,FBSDKLoginButtonDelegate,FBLoginDelegate {
    
    static var instance:FbLogin!
    var delegate:FBLoginDelegate!
    var  loginView  = FBSDKLoginButton()
    static func getInstance()->FbLogin{
        if(instance == nil){
            instance = FbLogin()
            
            instance.initButton()
        }
        return instance
    }
    func updateStatus(status:Bool){
        if(delegate != nil){
           delegate.onFbLoggedIn(status)
        }
    }
    func initButton(){
        delegate = self
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
    }
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    func logIn(withDelegate:FBLoginDelegate){
        self.delegate = withDelegate
         loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    static func logIn(withDelegate:FBLoginDelegate){
         getInstance().logIn(withDelegate);
           }
    static func logIn(){
    getInstance().loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    static func getAssessTocken()->FBSDKAccessToken{
         return FBSDKAccessToken.currentAccessToken()
    }
    static func isLoggedIn()->Bool{
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
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
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            updateStatus(false)

        }
        else if result.isCancelled {
            // Handle cancellations
            updateStatus(false)

        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                updateStatus(true)

              //  FbLogin.returnUserData();
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        updateStatus(false)
    }
    
    static func returnUserData()
    {
        if(FbLogin.isLoggedIn()){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,name,email", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
        }
    }
    func onFbLoggedIn(status: Bool) {
        // NO delegate Set
    }

}
