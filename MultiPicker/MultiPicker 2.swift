//
//  MultiPicker.swift
//  Created by Mzalih on 28/12/15.
//  Copyright © 2015 Toobler. All rights reserved.
//

import UIKit



class MultiPicker :NSObject,UITableViewDataSource,UITableViewDelegate {
    
    var selectedList :NSMutableArray = NSMutableArray();
    var availableList :NSArray = NSMutableArray();
    var padding:CGFloat = 58.0;
    var tableView:UITableView!
    var fullView:UIView = UIView()
    var isSingleSelection = false;
    var whiteView:UIView?
    var transpView:UIView?
    
    var successHolder: ((multiPicker:MultiPicker!,status:Bool) -> Void)?
    func setonClose(sucess:((multiPicker:MultiPicker!,status:Bool) -> Void)){
        successHolder = sucess
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            
            var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("searchCellIdentifier", forIndexPath: indexPath)  as UITableViewCell
            
            if(cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "searchCellIdentifier")
                cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
            }
            let item : Category = availableList.objectAtIndex(indexPath.row) as! Category;
            
            cell?.textLabel?.text = item.category_name
            cell?.textLabel?.font = Constants.getThinFont(12)
            if(selectedList.containsObject(item)){
                cell?.imageView?.image = Constants.getTick();
            }else{
                cell?.imageView?.image = Constants.getUnTick();
                
            }
            return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableList.count
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    }
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath){
            let item : Category = availableList.objectAtIndex(indexPath.row) as! Category;
            if(isSingleSelection){
                selectedList.removeAllObjects()
                selectedList.addObject(item)
            }else{
                if(selectedList.containsObject(item)){
                    selectedList.removeObject(item)
                }else{
                    selectedList.addObject(item)
                }
            }
            tableView.reloadData();
    }
    //Mark: Hide keyboard when touch out side
    
    func handleSingleTap(sender :UITapGestureRecognizer)
    {
        hideView()
    }
    func show(withinView:UIView){
        fullView = UIView()
        fullView.frame = withinView.frame;
        fullView.backgroundColor = UIColor.clearColor();
        
        transpView = UIView(frame: fullView.frame)
        transpView!.backgroundColor = UIColor.blackColor()
        transpView!.alpha = 0.0;
        fullView.addSubview(transpView!)
        let tapper = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapper.cancelsTouchesInView = false
        transpView!.addGestureRecognizer(tapper)
        
        let frame = CGRect(x: 0 , y: padding , width: 200 , height: (withinView.frame.size.height - (padding*3)) );
        let fullheight = CGRect(x: -200 , y: 0 , width: 200 , height: (withinView.frame.size.height) );
        let buttonFrame = CGRect(x: 25 , y: frame.height + padding+10, width: 150, height:30 )
        
        let closeButton : UIButton = UIButton(frame: buttonFrame);
        closeButton.addTarget(self, action: "hideAction:", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.backgroundColor = Constants.getBlueColor()
        closeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeButton.layer.cornerRadius = 3
        closeButton.setTitle(Constants.KEY_DONE ,forState: UIControlState.Normal)
        
        tableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        tableView.delegate      = self;
        tableView.dataSource    = self;
        tableView.allowsSelection = true;
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "searchCellIdentifier")
        
        whiteView =  ShadowView(frame: fullheight)
        whiteView!.backgroundColor = UIColor.whiteColor()
        
        whiteView!.addSubview(tableView)
        whiteView!.addSubview(closeButton)
        fullView.addSubview(whiteView!)
        withinView.addSubview(fullView)
        UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
            var basketTopFrame = self.whiteView!.frame
            basketTopFrame.origin.x += basketTopFrame.size.width
            self.transpView!.alpha = 0.6;
            self.whiteView!.frame = basketTopFrame
            }, completion: { finished in
                print("Basket doors opened!")
        })
        
        
        
        
    }
    func checkExistat(index:Int)->Bool{
        let item : Category = availableList.objectAtIndex(index) as! Category;
        return (selectedList.containsObject(item))
    }
    
    func addOrRemove(index:Int){
        let item : Category = availableList.objectAtIndex(index) as! Category;
        if(selectedList.containsObject(item)){
            selectedList.removeObject(item)
        }else{
            selectedList.addObject(item)
        }
    }
    @IBAction func hideAction(sender: AnyObject) {
        hideView()
        if(successHolder != nil){
            successHolder!(multiPicker: self ,status: true)
        }
    }
    func hideView(){
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations: {
            var basketTopFrame = self.whiteView!.frame
            basketTopFrame.origin.x -= basketTopFrame.size.width
            self.whiteView!.frame = basketTopFrame
            self.transpView!.alpha = 0.0;
            }, completion: { finished in
                
                self.fullView.removeFromSuperview();
        })
    }
    
}