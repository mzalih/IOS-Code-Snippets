//
//  PickImage.swift
//  Created by Mzalih on 12/01/16.

import UIKit

class PickImage :NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  UIActionSheetDelegate {
    
    var successHolder: ((image:UIImage!,status:Bool) -> Void)?
    var viewController:UIViewController?
    func getImage(view:UIViewController,withSuccessHandler success: (image:UIImage!,status:Bool) -> Void){
        viewController = view
        let myActionSheet = UIActionSheet()
        successHolder = success;
        myActionSheet.delegate = self
        myActionSheet.addButtonWithTitle("From Camera")
        myActionSheet.addButtonWithTitle("From Gallery")
        myActionSheet.addButtonWithTitle("Cancel")
        myActionSheet.cancelButtonIndex = 2
        myActionSheet.showInView(view.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            //PICK FROM CAMEREA
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            viewController!.presentViewController(imagePicker, animated: true, completion: nil)
            
        }else if(buttonIndex == 0){
            //PICK FROM GALLERY
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.Camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.Camera
                    imagePicker.allowsEditing = false
                      viewController!.presentViewController(imagePicker, animated: true,
                        completion: nil)
            }else{    
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                viewController!.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            successHolder!(image: pickedImage,status: true);
        }
        viewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
