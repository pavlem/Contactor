//
//  ContactCell.swift
//  SatBridge
//
//  Created by Pavle Mijatovic on 3/8/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
  
  @IBOutlet weak var w: NSLayoutConstraint!
  @IBOutlet weak var h: NSLayoutConstraint!
  @IBOutlet weak var contactImage: UIImageView!
  @IBOutlet weak var fullName: UILabel!
  @IBOutlet weak var phone: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
//    w.constant = 20
//    h.constant = 20
  }
  
  
  override func prepareForReuse() {
    contactImage.image = UIImage(named: "avatar")
  }
  
}
