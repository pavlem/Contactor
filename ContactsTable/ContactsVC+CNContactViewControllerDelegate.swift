//
//  ContactsVC+CNContactViewControllerDelegate.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import ContactsUI

extension ContactsVC: CNContactViewControllerDelegate {
  
  func contactViewController(vc: CNContactViewController, didCompleteWithContact con: CNContact?) {
    self.tabBarController?.tabBar.hidden = false
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func contactViewController(vc: CNContactViewController, shouldPerformDefaultActionForContactProperty prop: CNContactProperty) -> Bool {
    return false
  }
}