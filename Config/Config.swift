   //
   //  Config.swift   //
   //  Created by Mzalih on 31/12/15.
   //  Copyright © 2015 Mzalih Technologies. All rights reserved.
   //
   
   import UIKit
   class Config: NSObject {
    static var activeAlert:ZAlertView?
    
    // MARK:
    // MARK: User Defaults Handling
    
    // GET A STRING VALUE
    static func getStringValue(key:String ,withDefault :String)->NSString{
        if let value = NSUserDefaults.standardUserDefaults().stringForKey(key) {
            return value
        }
        return withDefault
    }
    // GET A BOOL VALUE
    static func getBoolValue(key:String )->Bool{
        return  NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    // SET A BOOL VALUE
    static func setBoolValue(key:String ,status :Bool ){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(status, forKey: key)
        userDefaults.synchronize()
    }
    // SET A STRING VALUE
    static func setStringValue(key:String ,status :String ){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(status, forKey: key)
        userDefaults.synchronize()
    }
    // GET MY USER ID
    static func getUserId()->String{
        return Config.getStringValue(Constants.UD_MYUSERID, withDefault: Constants.KEY_EMPTY) as String
    }
    // GET MY USER ID
    static func getApiKey()->String{
        return Config.getStringValue(Constants.UD_API_KEY, withDefault: Constants.KEY_EMPTY) as String
    }
    static func setupPlaceHolder(myTextField:UITextField,string :String){
        
        myTextField.attributedPlaceholder = NSAttributedString(string:string,
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    // MARK: Hide KeuBoard
    
    //MARK: Add a drop Shadow
    static func addShadow(view :UIView){
        
        let shadowPath = UIBezierPath(rect: view.bounds)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowPath = shadowPath.CGPath
        view.layer.shadowOffset = CGSizeZero
        if( view.layer.cornerRadius > 1){
            view.layer.shadowRadius = view.layer.cornerRadius + 1
        }else{
            view.layer.shadowRadius = 1
        }
    }
    
    static let waterfallPageCout:Int = 20
    static func getHeight(label:UILabel)->CGFloat{
        
        let labelWidth = label.frame.width
        
        let maxLabelSize = CGSize(width: labelWidth, height: CGFloat.max)
        let actualLabelSize = label.text!.boundingRectWithSize(maxLabelSize, options: [.UsesLineFragmentOrigin], attributes: [NSFontAttributeName: label.font], context: nil)
        return actualLabelSize.height
        
    }
    static func getWidth(label:UILabel)->CGFloat{
        
        let labelWidth = label.frame.width
        let maxLabelSize = CGSize(width: labelWidth, height: CGFloat.max)
        let actualLabelSize = label.text!.boundingRectWithSize(maxLabelSize, options: [.UsesLineFragmentOrigin], attributes: [NSFontAttributeName: label.font], context: nil)
        return actualLabelSize.width
        
    }
    static func color(hexString: String) -> UIColor? { 
        if (hexString.characters.count > 7 || hexString.characters.count < 7) {
            return nil
        } else {
            let hexInt = Int(hexString.substringFromIndex(hexString.startIndex.advancedBy(1)), radix: 16)
            if let hex = hexInt {
                let components = (
                    R: CGFloat((hex >> 16) & 0xff) / 255,
                    G: CGFloat((hex >> 08) & 0xff) / 255,
                    B: CGFloat((hex >> 00) & 0xff) / 255
                )
                return UIColor(red: components.R, green: components.G, blue: components.B, alpha: 1)
            } else {
                return nil
            }
        }
    }
    static func showAlert(var title:String?,message:String){
        hideAlert()
        if(title == nil){
            title = Constants.MESSAGE_APP_NEME
        }
        activeAlert = ZAlertView(title: title, message:message, alertType:  ZAlertView.AlertType.Alert);activeAlert!.show()
    }
    static func hideAlert(){
        if((activeAlert) != nil){
            activeAlert?.dismiss()
        }
    }
    static func showAlert(var title:String?,message:String,withClick success:
        (status:Bool) -> Void){
            hideAlert()
            if(title == nil){
                title = Constants.MESSAGE_APP_NEME
            }
            let dialog =    ZAlertView(title: title, message: message, okButtonText:Constants.KEY_DONE, cancelButtonText: Constants.KEY_CANCEL)
            dialog.okHandler = { alertView in
                //OPEN CHAT PAGE
                success(status: true)
                alertView.dismiss()
            }
            dialog.cancelHandler = { alertView in
                success(status: false)
                alertView.dismiss()
            }
            activeAlert = dialog
            dialog.show();
            
    }
    static func trim(myString:String)->String{
        // TRIM A STRING
        return myString.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
    }
    static func formatDate(date:NSDate,format:String,clipped:Bool)->String{
        let df = NSDateFormatter()
        df.dateFormat = format
        if let resultString:String = df.stringFromDate(date){
            return resultString
        }
        return Constants.KEY_EMPTY
    }
   }
