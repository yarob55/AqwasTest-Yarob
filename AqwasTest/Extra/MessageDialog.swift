//
//  MessageDialog.swift
//  GMapsPractice
//
//  Created by يعرب المصطفى on 5/10/18.
//  Copyright © 2018 yarob. All rights reserved.
//

import Foundation
import PopupDialog

//this class is used to show a pop up message using the popupdialog library
class MessageDialog
{
    //Reusable code: dpendencies: PopupDialog library
    //this function is used to show a message with title and message text with done button
    //params: title - message - view:the view where the message will be displayed: this is mostly going to be self if you call the method from a viewcontroller
    static func showMessage(title: String, message: String, vc:UIViewController)
    {
        let title = title
        let message = message
        
        //this message is not actually used in the code
        let image = UIImage(named: "pexels-photo-103290")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        
        // This button will not the dismiss the dialog
        let btn = DefaultButton(title: "تم", dismissOnTap: true) {
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([btn])
        
        // Present dialog
        vc.present(popup, animated: true, completion: nil)
    }
}
