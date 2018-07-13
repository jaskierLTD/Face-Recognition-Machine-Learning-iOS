//
//  PersonTableViewCell.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell
{
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var typeImage:UIImageView!
    @IBOutlet weak var photo:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var time:UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.content.backgroundColor = UIColor(patternImage: UIImage(named: "pattern_grey_linen")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: false)
    }

}
