```
//  Created by Mzalih on 28/12/15.
//  Copyright © 2015 Toobler. All rights reserved.
//

```
0. Copy FbLogin folder and all its contents to your project from this repo.<br><br>

1. Visit the Getting Started with the Facebook iOS SDK documentation to download the Facebook SDK and install it.<br>
<br>
2. Add the FacebookSDKCoreKit.Framework to your project as you normally would. Drag it or add it using the “Linked Frameworks and Libraries” within your target settings.(Copy the files never link reference)<br>
<br>
3. You won’t be able to use the normal #import <FBSDKCoreKit/FBSDKCoreKit.h> to link the framework so you need to do a work around by creating a Bridging Header.<br> 
<br> 


~~4. Create a new “Objective-C” Header file by clicking “File > New” <br>
<br>
All you need in the Bridging-Header.h is the import statement for the Facebook SDK.~~
<br>
<br>

```
#ifndef FacebookTutorial_Bridging_Header_h
#define FacebookTutorial_Bridging_Header_h

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#endif

```
<br>
<br>

 5 . Add it to your target’s build settings:
<br>In Xcode, if you go into the build settings for your target, and scroll all the way down you’ll find a “Swift Compiler – Code Generation” section.<br>

Set “Objective-C Bridging Header” to <#PROJECT_NAME>/FBLogin/Bridging-Header.h<br>

 6. “Install Objective-C Compatibility Header”, should be set to “Yes”.<br>

Here’s what it looks like:

<img src="https://raw.githubusercontent.com/mzalih/IOS-Code-Snippets/master/Fblogin/look.png"><br><br>
7. Now your app should be able to access all of the APIs in the Facebook SDK.<br><br>
8. Add the following to your AppDelegate.swift. The “OpenURL” method allows your app to open again after the user has validated their login credentials.<br>.<br>
9. The FBSDKAppEvents.activateApp() method allows Facebook to capture events within your application including Ads clicked on from Facebook to track downloads from Facebook and events like how many times your app was opened. <br><br>
``` 
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return FbLogin.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FbLogin.application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
   
}

```
</hr>

<h3>Facebook Login for iOS</h3>
<br>
	Now we’ll setup our app to use Facebook Login. </br>

~~1. Add the FacebookSDKLoginKit.Framework & Bolts.framework to your project just like your did with the FacebookSDKCoreKit.Framework. Drag it or add it using the “Linked Frameworks and Libraries” within your target settings.
    <br> 

2.  Add the following import statement to your Bridging-Header.h, right below the Core Kit entry.~~

``` swift 
    #import <FBSDKLoginKit/FBSDKLoginKit.h>
```

   3.  Add the Facebook Login button to your ViewController.swift.
   4. After you add the button, you should update your view controller to check for an existing token at load. This eliminates an unnecessary app switch to Facebook if someone already granted permissions to your app.
   5. When you add Facebook Login, your app can ask someone for permissions on a subset of that person’s data. Use the readPermissions or publishPermissions property of the FBSDKLoginButton. 


``` swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
```
Using the FBSDKLoginButtonDelegate Methods<br>

Add in the additional code for the FBSDKLoginButtonDelegate. This is helpful to know if the user did login correctly and if they did you can grab their information.
<br>
First add the delegate FBSDKLoginButtonDelegate to the class definition.
<br>
``` swift
class ViewController: UIViewController, FBSDKLoginButtonDelegate {

 //   Add the following callback methods to your View Controller.

        // Facebook Delegate Methods
        
        func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
            println("User Logged In")
            
            if ((error) != nil)
            {
                // Process error
            }
            else if result.isCancelled {
                // Handle cancellations
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email")
                {
                     // Do work
                }
            }   
        }
        
        func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
            println("User Logged Out")
        }
```
    Here is an extra method to grab the Users Facebook data. You can call this method anytime after a user has logged in by calling self.returnUserData().
``` swift
        func returnUserData()
        {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
               
                if ((error) != nil)
                {
                    // Process error
                    println("Error: \(error)")
                }
                else
                {
                    println("fetched user: \(result)")
                    let userName : NSString = result.valueForKey("name") as! NSString
                    println("User Name is: \(userName)")
                    let userEmail : NSString = result.valueForKey("email") as! NSString
                    println("User Email is: \(userEmail)")
                }
            })
        }
```
Enter your Facebook App Information

<br>From the Facebook SDK folder, drag the folder FBSDKCoreKit.Framework, FBSDKLoginKit.Framework, FBSDKShareKit.Framework into your Xcode Projects <br>
Framework folder. Uncheck "Copy into destination group folder".<br>
Configure your info.plist<br>
Find the .plist file in the Supporting Files folder in your Xcode Project.<br>
1. Right-click your .plist file and choose "Open As Source Code". <br>
2. Copy & Paste the XML snippet into the body of your file ( <dict>...</dict> ).
<br>

``` xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
  <key>CFBundleURLSchemes</key>
  <array>
    <string>fb1234567890</string>
  </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>1234567890</string>
<key>FacebookDisplayName</key>
<string>logZalihNow</string>
```
<br>
3. If you compile your app with iOS SDK 9.0 or above, you will be affected by App Transport Security. Currently, you will need to whitelist Facebook domains in your app by adding the following to your application's .plist.
</br>

``` xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>facebook.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
        <key>fbcdn.net</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
        <key>akamaihd.net</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
    </dict>
</dict>
```
<br>
4. If you use any of the Facebook dialogs (e.g., Login, Share, App Invites, etc.) that can perform an app switch to Facebook apps, your application's .plist also need to handle this.
</br>

``` xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```

``` swift

```