//
//  MultiPicker.swift
//  WorkoutBunnies
//
//  Created by Mzalih on 28/12/15.
//  Copyright © 2015 Toobler. All rights reserved.
//

import UIKit



class MultiPicker :NSObject,UITableViewDataSource,UITableViewDelegate {
   
    var selectedList :NSMutableArray = NSMutableArray();
    var availableList :NSArray = NSMutableArray();
    var padding:CGFloat = 40.0;
    var tableView:UITableView = UITableView()
    var fullView:UIView = UIView()
    

    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            
            var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("searchCellIdentifier", forIndexPath: indexPath)  as UITableViewCell
            
                    if(cell == nil) {
                        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "searchCellIdentifier")
                        cell!.selectionStyle = UITableViewCellSelectionStyle.None
                    }
                    let item : NSDictionary = availableList.objectAtIndex(indexPath.row) as! NSDictionary;
            
                    cell?.textLabel?.text = item.objectForKey("code")  as? String
            
            if(selectedList.containsObject(item)){
                cell?.imageView?.image = UIImage(named:"check");
            }else{
                 cell?.imageView?.image = UIImage(named:"check_no");
               
            }
                    return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableList.count
    }
     func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath){
            let item : NSDictionary = availableList.objectAtIndex(indexPath.row) as! NSDictionary;
            if(selectedList.containsObject(item)){
                selectedList.removeObject(item)
            }else{
                selectedList.addObject(item)
            }
            tableView.reloadData();
    }
    
    func show(withinView:UIView){
        fullView.frame = withinView.frame;
        fullView.backgroundColor = UIColor.clearColor();
        
        let transpView : UIView = UIView(frame: fullView.frame)
        transpView.backgroundColor = UIColor.blackColor()
        transpView.alpha = 0.8;
        fullView.addSubview(transpView)
        
        
        
        let frame = CGRect(x: padding , y: padding , width: withinView.frame.size.width - (padding*2) , height: (withinView.frame.size.height - (padding*3)) );
        
        let buttonFrame = CGRect(x: padding , y: frame.height + padding, width: frame.width, height:padding )
        
        
        let closeButton : UIButton = UIButton(frame: buttonFrame);
        closeButton.addTarget(self, action: "hideAction:", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.backgroundColor = UIColor.init(red: 0.5, green: 1.0, blue: 0.1, alpha: 1.0)
        closeButton.setTitle("Close", forState: UIControlState.Normal)
        
        let tableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        tableView.dataSource    = self;
        tableView.delegate      = self;
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "searchCellIdentifier")
        
        fullView.addSubview(tableView)
        fullView.addSubview(closeButton)
        withinView.addSubview(fullView)

        
    }
    func checkExistat(index:Int)->Bool{
        let item : NSDictionary = availableList.objectAtIndex(index) as! NSDictionary;
        return (selectedList.containsObject(item))
    }
    
    func addOrRemove(index:Int){
        let item : NSDictionary = availableList.objectAtIndex(index) as! NSDictionary;
        if(selectedList.containsObject(item)){
            selectedList.removeObject(item)
        }else{
            selectedList.addObject(item)
        }
    }
     @IBAction func hideAction(sender: AnyObject) {
        fullView.removeFromSuperview();
    }
    

}
