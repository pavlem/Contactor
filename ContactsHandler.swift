//
//  ContactsHandler.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI
import UIKit


struct CustomContact {
  var fullName : String?
  var phoneNumber : String?
  var imageData: NSData?
  
  init(fullName: String, phoneNumber: String) {
    self.fullName = fullName
    self.phoneNumber = phoneNumber
  }
}


class ContactsHandler  {
  
  class func createContactVC() -> CNContactViewController {
    let store = CNContactStore()
    let contact = CNMutableContact()
    let controller = CNContactViewController(forNewContact: contact)
    controller.contactStore = store
    
    return controller
  }
  
  class func getContactsDictionary(forContactsSectionTitles contactsSectionTitles: [String], fromContactList contactList: [CustomContact]) -> [String: [CustomContact]] {
    
    var contactsDictionary = [String: [CustomContact]]()
    
    for key in contactsSectionTitles {
      var tempContactsForKey = [CustomContact]()
      for contact in contactList {
        if key == contact.fullName?.first {
          tempContactsForKey.append(contact)
        }
      }
      
      contactsDictionary[key] = tempContactsForKey
    }
    
    return contactsDictionary
  }
  
  
  class func extractPropertiesFromContact(cnContact: CNContact) -> (fullname: String, phoneNumber: String, thumbnailImageData: NSData?) {
    
    let givenN = cnContact.givenName
    let familyName = cnContact.familyName
    let fullName = givenN + " " + familyName
    var phoneNumberString = ""
    
    if let phoneNumber = cnContact.phoneNumbers.first {
      let phoneNumber = phoneNumber.value as! CNPhoneNumber
      phoneNumberString = phoneNumber.stringValue
    }
    
    let thumbnailImageData = cnContact.thumbnailImageData
    
    return (fullName, phoneNumberString, thumbnailImageData)
  }
}
