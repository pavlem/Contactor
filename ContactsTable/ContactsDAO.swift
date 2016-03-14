//
//  ContactsDAO.swift
//  SatBridge
//
//  Created by Pavle Mijatovic on 3/2/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import Foundation
import Contacts

class ContactsDAO {
  
  class func getAllContacts() -> [CNContact] {
    
    let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey]
    let containerId = CNContactStore().defaultContainerIdentifier()
    let predicate: NSPredicate = CNContact.predicateForContactsInContainerWithIdentifier(containerId)
    
    var contacts = [CNContact()]
    
    do {
      contacts = try CNContactStore().unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
      
    } catch {
      
    }
    return contacts
  }
}