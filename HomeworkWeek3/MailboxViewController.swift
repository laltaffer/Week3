//
//  MailboxViewController.swift
//  Week3
//
//  Created by Altaffer, Lawrence on 4/14/16.
//  Copyright © 2016 Altaffer, Lawrence. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var mainVIew: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var rescheduledView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var theMenuView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet var didPanOnMessageImageView: UIPanGestureRecognizer!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
   
    var initialCenter: CGPoint!
    var messageInitialCenter :CGPoint!
    var feedInitialCenter: CGPoint!
    var laterIconInitialCenter: CGPoint!
    var archiveIconInitialCenter: CGPoint!
    
    let greyColor = UIColor(red: 204/255, green: 205/255, blue: 210/255, alpha: 1.0)
    let yellowColor = UIColor(red: 253/255, green: 237/255, blue: 14/255, alpha: 1.0)
    let brownColor = UIColor(red: 165/255, green: 101/255, blue: 16/255, alpha: 1.0)
    let greenColor = UIColor(red: 101/255, green: 210/255, blue: 61/255, alpha: 1.0)
    let redColor = UIColor(red: 219/255, green: 34/255, blue: 34/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        scrollView.contentSize = CGSize(width: 320, height: 1350)
        
        rescheduledView.alpha = 0
        listView.alpha = 0
        archiveIcon.alpha = 0
        laterIcon.alpha = 0

        messageInitialCenter = messageImage.center
        laterIconInitialCenter = laterIcon.center
        archiveIconInitialCenter = archiveIcon.center
        feedInitialCenter = feedView.center
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didPanMessageView(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            messageImage.center.x = messageInitialCenter.x + translation.x
            if translation.x <= -60 && translation.x >= -240 {
                self.laterIcon.center.x = self.laterIconInitialCenter.x + translation.x + 60
                self.laterIcon.alpha = 1
                self.archiveIcon.alpha = 0
                self.laterIcon.image = UIImage(named: "later_icon")
                self.messageView.backgroundColor = yellowColor
            }
                
            else if translation.x < -240 {
                self.laterIcon.center.x = self.laterIconInitialCenter.x + translation.x + 60
                self.laterIcon.alpha = 1
                self.laterIcon.image = UIImage(named: "list_icon")
                self.messageView.backgroundColor = brownColor
            }
                
            else if translation.x >= 60 && translation.x <= 240 {
                self.archiveIcon.center.x = self.archiveIconInitialCenter.x + translation.x - 60
                self.archiveIcon.image = UIImage(named: "archive_icon")
                self.archiveIcon.alpha = 1
                self.laterIcon.alpha = 0
                
                self.messageView.backgroundColor = greenColor
            }
                
            else if translation.x > 240 {
                self.archiveIcon.center.x = self.archiveIconInitialCenter.x + translation.x - 60
                self.archiveIcon.alpha = 1
                self.archiveIcon.image = UIImage(named: "delete_icon")
                self.messageView.backgroundColor = redColor
            }
                
            else {
                self.archiveIcon.alpha = 0.3
                self.laterIcon.alpha = 0.3
                self.messageView.backgroundColor = greyColor
            }
            
            
        }
            
        else if sender.state == UIGestureRecognizerState.Ended {
            if translation.x <= -60 && translation.x >= -240 {
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageImage.center.x = self.messageInitialCenter.x - 320
                    self.laterIcon.alpha = 0
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            self.rescheduledView.alpha = 1
                            self.showReschedule()
                            }, completion: { (Bool) -> Void in
                                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
                        })
                })
            } else if translation.x < -240 {
                UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageImage.center.x = self.messageInitialCenter.x - 320
                    self.laterIcon.alpha = 0
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            self.listView.alpha = 1
                            }, completion: { (Bool) -> Void in
                                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
                        })
                })
            } else if translation.x >= 60 && translation.x <= 240 {
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageImage.center.x = self.messageInitialCenter.x + 320
                    self.archiveIcon.alpha = 0
                    }, completion: { (Bool) -> Void in
                        self.hideThenRevealAgain()
                })
            } else if translation.x > 240 {
                UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.messageImage.center.x = self.messageInitialCenter.x + 320
                    self.archiveIcon.alpha = 0
                    }, completion: { (Bool) -> Void in
                        self.hideThenRevealAgain()
                })
            } else {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 15, options: [], animations: { () -> Void in
                    self.messageImage.center.x = self.messageInitialCenter.x
                    }, completion: { (Bool) -> Void in
                        //code
                })
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageView.backgroundColor = self.greyColor
                    self.laterIcon.image = UIImage(named: "later_icon")
                    self.archiveIcon.image = UIImage(named: "archive_icon")
                    self.laterIcon.alpha = 0.3
                    self.archiveIcon.alpha = 0.3
                })
            }
        }
    }
    
    
    
    
    
    func showReschedule() {
        rescheduledView.alpha = 1
    }
    
    
    func hideReschedule() {
        rescheduledView.alpha = 0
    }
    
    
    @IBAction func didTapList(sender: AnyObject) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.listView.alpha = 0
        }) { (Bool) -> Void in
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            self.hideThenRevealAgain()
        }
    }
    
    
    @IBAction func didTapRescheduledView(sender: AnyObject) {
            hideReschedule()
            UIView.animateWithDuration(0.2, delay: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.rescheduledView.alpha = 0
            }) { (Bool) -> Void in
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
                self.hideThenRevealAgain()
            }

    }
    

    
    
    func hideThenRevealAgain() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.feedView.center.y = self.feedInitialCenter.y - 86
            }, completion: { (Bool) -> Void in
                self.messageImage.backgroundColor = UIColor(red: 204/255, green: 205/255, blue: 210/255, alpha: 1.0)
                self.messageImage.center.x = self.messageInitialCenter.x
                self.archiveIcon.image = UIImage(named: "archive_icon")
                self.laterIcon.image = UIImage(named: "later_icon")
                self.archiveIcon.alpha = 0.3
                self.laterIcon.alpha = 0.3
                self.archiveIcon.center.x = self.archiveIconInitialCenter.x
                self.laterIcon.center.x = self.laterIconInitialCenter.x
                UIView.animateWithDuration(0.3, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.feedView.center.y = self.feedInitialCenter.y
                    }, completion: { (Bool) -> Void in
                        
                })
        })
    }
    
   
    
    @IBAction func tapMenuButton(sender: AnyObject) {
        
        if menuButton.selected == false {
           
            UIView.animateWithDuration(0.5, delay: 0, options: [], animations: { () -> Void in
                self.scrollView.center.x = 440
                self.navView.center.x = 440
            }) { (Bool) -> Void in
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
            }
            self.menuButton.selected = true
            
        }else if menuButton.selected == true {
            UIView.animateWithDuration(0.5, delay: 0, options: [], animations: { () -> Void in
                self.scrollView.center.x = self.mainVIew.center.x
                self.navView.center.x = self.mainVIew.center.x
                }, completion: { (Bool) -> Void in
                    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            })
            self.menuButton.selected = false
        }
        
        
    }
 
    
    

}
