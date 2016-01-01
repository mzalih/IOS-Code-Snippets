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

Set “Objective-C Bridging Header” to <#PROJECT_NAME>/Bridging-Header.h<br>

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

~~1. Add the FacebookSDKLoginKit.Framework & Bolts.framework to your project just like your did with the FacebookSDKCoreKit.Framework. Drag it or add it using the “Linked Frameworks and Libraries” within your target settings.~~
    <br> </br>

~~2.  Add the following import statement to your Bridging-Header.h, right below the Core Kit entry.~~

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

    Add in the additional code for the FBSDKLoginButtonDelegate. This is helpful to know if the user did login correctly and if they did you can grab their information.<br>
    First add the delegate FBSDKLoginButtonDelegate to the class definition.<br>
```
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
```
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

    There is one final step needed to be performed, and that is to add three new keys to the project’s .plist file. So, open it by clicking on the Supporting Files group in the Project Navigator and then on the Info.plist file. Add a new key named FacebookAppID, and as its value paste the App ID value which you can copy from the Facebook dashboard, at the top of it. Similarly, add the FacebookDisplayName key, and in its value paste the Display Name.Finally, create a new key named URL Types, and set its type to array with one item only. Give it the URL Schemes title and make it an array too. In the one and only item that should be contained, set the app ID value you copied from the Facebook dashboard, prefixing it with the fb literal. The image below shows all the three additions on the .plist file:
    Screen Shot 2015-03-27 at 10.12.39 AM
    Compile your project and you should see the following screen. Once you click the “Log in with Facebook” button, it should kick you out to the Facebook App or the Facebook website for the user to login. After they have, it’ll kick back to your app and you’ll see the user information in the console.
    Screen Shot 2015-03-27 at 11.43.09 AM
    Now it’s up to you to use the users information as you wish. Maybe to populate a user profile or to pull the users Facebook friends so you can build a leaderboard. 



``` swift

```