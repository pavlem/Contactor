//
//  ContactsVC+UITableViewDataSource.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import Foundation
import UIKit

extension ContactsVC {
    
  override func numberOfSectionsInTableView(tableView:UITableView)->Int {
    if searchController.active && searchController.searchBar.text != "" {
      return 1
    }
    return self.contactsSectionTitles.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.active && searchController.searchBar.text != "" {
      return self.contactsFiltered.count
    }
    
    let sectionTitle = contactsSectionTitles[section]
    let sectionContacts = contactsDictionary[sectionTitle]!
    
    return sectionContacts.count
  }
  
  override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    return self.contactsSectionTitles
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return contactsSectionTitles[section]
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
    var contact = contacts[indexPath.row]
    
    if searchController.active && searchController.searchBar.text != "" {
      contact = contactsFiltered[indexPath.row]
    } else {
      
      let sectionTitle = contactsSectionTitles[indexPath.section]
      let sectionContacts = contactsDictionary[sectionTitle]!
      
      contact = sectionContacts[indexPath.row]
    }
    
    cell.fullName.text = contact.fullName
    
    if let phoneNumb = contact.phoneNumber {
      cell.phone.text = phoneNumb
      cell.phone.hidden = false
    }
    
    if let thumbImage = contact.imageData {
      
      cell.contactImage.image = UIImage(data:thumbImage)
      cell.contactImage.layer.cornerRadius = 25.0
      cell.contactImage.layer.masksToBounds = true
    }
    
    return cell
  }
}