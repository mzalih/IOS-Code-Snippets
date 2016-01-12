``` swift
//  MultiPicker.swift
//
//  Created by Mzalih on 28/12/15.

```
How To Use

``` swift
let pick = PickImage();
@IBAction func onClickImageUpload(sender: AnyObject) {

pick.getImage(self) { (image, status) -> Void in
let btn:UIButton = sender as! UIButton
btn.setImage(image, forState: UIControlState.Normal)
}
}
 ```