//
//  ContactsVC+UIAlertController.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import Foundation
import UIKit

extension ContactsVC {
  
  
  // MARK: - Private
  private func sendSmsToContact(contact:CustomContact) {
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.redColor()
    self.navigationController?.pushViewController(newVC, animated: true)
    self.navigationItem.title = contact.fullName
    self.tabBarController?.tabBar.hidden = true
  }
  
  private func callContact(contact:CustomContact) {
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.greenColor()
    self.navigationController?.pushViewController(newVC, animated: true)
    self.navigationItem.title = contact.fullName
    self.tabBarController?.tabBar.hidden = true
  }
  
  
  // MARK: - Public
  func createActionSheet(indexPath: NSIndexPath) {
    
    var contact = CustomContact(fullName: "", phoneNumber: "")
    
    if searchController.active && searchController.searchBar.text != "" {
      contact = contactsFiltered[indexPath.row]
    } else {
      let sectionTitle = contactsSectionTitles[indexPath.section]
      let sectionContacts = contactsDictionary[sectionTitle]!
      
      contact = sectionContacts[indexPath.row]
      
    }
    
    // 1
    let optionMenu = UIAlertController(title: nil, message: contact.fullName, preferredStyle: .ActionSheet)
    
    // 2
    let callAction = UIAlertAction(title: "PHONE", style: .Default, handler: {
      (alert: UIAlertAction!) -> Void in
      self.callContact(contact)
      print("PHONE")
    })
    let smsAction = UIAlertAction(title: "SMS", style: .Default, handler: {
      (alert: UIAlertAction!) -> Void in
      
      self.sendSmsToContact(contact)
      print("SMS")
    })
    
    // 3
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
      (alert: UIAlertAction!) -> Void in
      print("Cancelled")
    })
    
    // 4
    optionMenu.addAction(callAction)
    optionMenu.addAction(smsAction)
    optionMenu.addAction(cancelAction)
    
    // 5
    self.presentViewController(optionMenu, animated: true, completion: nil)
  }
}