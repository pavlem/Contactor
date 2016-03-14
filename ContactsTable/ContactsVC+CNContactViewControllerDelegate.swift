//
//  ContactsVC+CNContactViewControllerDelegate.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import ContactsUI

extension ContactsVC: CNContactViewControllerDelegate {
  
  // MARK: - CNContactViewControllerDelegate
  func contactViewController(vc: CNContactViewController, didCompleteWithContact con: CNContact?) {
    self.tabBarController?.tabBar.hidden = false
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func contactViewController(vc: CNContactViewController, shouldPerformDefaultActionForContactProperty prop: CNContactProperty) -> Bool {
    return false
  }
  
  // MARK: - Public
  func getContactsFromSystemContacts(cnContacts: [CNContact]) -> [CustomContact] {
    var contactsLocal = [CustomContact]()
    for cnContact in cnContacts {
      let contactProperties = ContactsHandler.extractPropertiesFromContact(cnContact)
      var customContact = CustomContact(fullName: contactProperties.fullname, phoneNumber: contactProperties.phoneNumber)
      if let thumbnailImageData = contactProperties.thumbnailImageData {
        customContact.imageData = thumbnailImageData
      }
      
      contactsLocal.append(customContact)
    }
    return contactsLocal
  }
  
  
  func getContactsAndSortThem() {
    
    self.contacts = getContactsFromSystemContacts(ContactsDAO.getAllContacts())
    
    for customContact in self.contacts {
      contactsFullNames.append(customContact.fullName!)
    }
    
    contactsFullNames = capitalizeFirstLetterInArrayOfStrings(contactsFullNames)
    contactsFullNames = contactsFullNames.sort() { $0 < $1 }
    contactsSectionTitles = getInitialsFromArrayOfStrings(contactsFullNames.initials)
    contactsDictionary = ContactsHandler.getContactsDictionary(forContactsSectionTitles: self.contactsSectionTitles, fromContactList: self.contacts)
  }


}