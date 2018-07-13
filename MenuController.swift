//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//
import UIKit

class MenuController: UITableViewController
{
    //override var prefersStatusBarHidden: Bool {return true}
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var frontView: UIView! // If you need a shadow

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        bgView.layer.cornerRadius = (bgView.bounds.width/2)
        frontView.layer.cornerRadius = (frontView.bounds.width/2)
        frontView.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
