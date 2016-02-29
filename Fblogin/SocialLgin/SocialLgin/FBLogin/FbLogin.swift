//
//  FbLogin.swift
//  SocialLgin
//
//  Created by Muhammed Salih on 01/01/16.
//  Copyright © 2016 Muhammed Salih T A. All rights reserved.
//
import FBSDKShareKit
import FBSDKCoreKit
import FBSDKLoginKit
protocol FBLoginDelegate{
    func onFbLoggedIn(status:Bool)
}
class FbLogin:NSObject,FBSDKLoginButtonDelegate,FBLoginDelegate,FBSDKAppInviteDialogDelegate,FBSDKSharingDelegate {
    
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
        logout()
        getInstance().loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    static func getAssessTocken()->FBSDKAccessToken{
        return FBSDKAccessToken.currentAccessToken()
    }
    static func getAssessTockenString()->String{
        return FBSDKAccessToken.currentAccessToken().tokenString
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
        
        // USER LOGGED OUT
        updateStatus(false)
    }
    static func logout(){
        FBSDKLoginManager().logOut()
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
                    /*
                    let userName : NSString = result.valueForKey("name") as! NSString
                    
                    let userEmail : NSString = result.valueForKey("email") as! NSString
                    */ 
                }
            })
        }
    }
    static func fbInvite(url:String,image:String,view:UIViewController){
        
        let content = FBSDKAppInviteContent()
        
        content.appLinkURL = NSURL(string: url);
        //optionally set previewImageURL
        content.appInvitePreviewImageURL = NSURL(string: image);
        
        // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
        FBSDKAppInviteDialog.showFromViewController(view, withContent: content, delegate: getInstance())
    }
    static func fbShare(url:String,image:String,message:String,view:UIViewController){
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        
        content.contentURL = NSURL(string: url)
        content.contentTitle = Constants.MESSAGE_APP_NEME
        content.contentDescription = message
        
        content.imageURL = NSURL(string:image)
        FBSDKShareDialog.showFromViewController(view, withContent: content, delegate: getInstance())
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        
    }
    func onFbLoggedIn(status: Bool) {
        // NO delegate Set
    }
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
    }
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
    
}
