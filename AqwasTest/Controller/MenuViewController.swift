//
//  MenuViewController.swift
//  AqwasTest
//
//  Created by يعرب المصطفى on 5/18/18.
//  Copyright © 2018 yarob. All rights reserved.
//

import UIKit
import Spring

class MenuViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cryingImageView: SpringImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var helpLabel: SpringLabel!
    @IBOutlet weak var messageLabel: SpringLabel!
    @IBOutlet weak var message2Label: SpringLabel!
    @IBOutlet weak var exMarkLabel: SpringImageView!
    
    var arrowImages = [SpringImageView]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollview.delegate = self
        helpLabel.isHidden = true
        exMarkLabel.isHidden = true
        messageLabel.alpha = 0.0
        makeRepeatedImages(image: #imageLiteral(resourceName: "down-arrow"), inView: contentView, amount: 14)
        
    }
    
    private func makeRepeatedImages(image:UIImage, inView view:UIView, amount:Int)
    {
        for i in 0..<amount
        {
            let imageview = SpringImageView(image: image)
            imageview.frame = CGRect(x: Int(self.contentView.frame.width/2), y: 300+i*150, width: 70, height: 70)
            imageview.center.x = exMarkLabel.center.x-70
            imageview.isHidden = true
            arrowImages.append(imageview)
            view.addSubview(imageview)
        }
    }
    
    private func fadeInArrows()
    {
        for i in arrowImages
        {
            i.animation = "fadeIn"
            i.isHidden = false
            i.duration = 0.8
            i.animateNext {
            }
        }
    }
    
    
    
    //animate the elements whenever the view appears (the menu opened)
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        helpLabel.isHidden = false
        exMarkLabel.animation = "fadeIn"
        helpLabel.animation = "fadeIn"
        helpLabel.curve = "linear"
        helpLabel.duration = 0.8
        helpLabel.animateNext
        {
            self.exMarkLabel.isHidden = false
            self.exMarkLabel.animateNext {
                    self.fadeInArrows()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //this delegated method is used to fade in and out the elements gradually according to the scrolling position
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("the pos of scrollview:",scrollview.contentOffset.y)
        
        cryingImageView.alpha = getAlphaValue(scrollview: scrollView, maxPoint: 2200, showPoint: 2100)
        messageLabel.alpha = getAlphaValue(scrollview: scrollView, maxPoint: 2300, showPoint: 2200)
        
        message2Label.alpha = getAlphaValue(scrollview: scrollView, maxPoint: 2500, showPoint: 2400)
    }
    
    
    //reusable function
    /*this function is used to show an element depending on how much scrolling is done
        the function takes the scrollview and the maximum value of the scrollview and the showpoint which is the point in which you want the element to start showing up and it returns a double value (between 0 and 1) that represents the alpha value for that element. so the returned value should be assigned to the element
     */
    private func getAlphaValue(scrollview:UIScrollView,maxPoint:Double,showPoint:Double)->CGFloat
    {
        let pos = scrollview.contentOffset.y
        let alpha = (Double(pos)-maxPoint)/(maxPoint-showPoint)
        return CGFloat(alpha)
    }
    
    private func showMessage()
    {
        messageLabel.isHidden = false
        messageLabel.animation = "fadeIn"
        messageLabel.curve = "linear"
        messageLabel.duration = 0.8
        messageLabel.animateNext
            {
                
        }
    }

}
