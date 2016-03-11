//  Created by Pavle Mijatovic on 2/26/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


class ContactsVC: UITableViewController, CNContactPickerDelegate {
  
  // MARK: - Properties
  var contacts = [CNContact]()
  var filteredContacts = [CNContact]()
  let searchController = UISearchController(searchResultsController: nil)
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchController()
    setupTableView()
    getUserData()
  }
  
  
  
  
  // MARK: - Private
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    definesPresentationContext = true
    searchController.dimsBackgroundDuringPresentation = false
    tableView.tableHeaderView = searchController.searchBar
    tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height);
  }
  
  private func getUserData() {
    
    let cnContacts = ContactsDAO.getAllContacts()
    
    for cnContact in cnContacts {
      self.contacts.append(cnContact)
    }
  }
  
  
  private func setupTableView() {
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.tableFooterView!.hidden = true
    tableView.backgroundColor = UIColor.whiteColor()
  }
  
  
  // MARK: - Delegates
  // MARK: UITableViewDataSource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.active && searchController.searchBar.text != "" {
      return self.filteredContacts.count
    }
    return self.contacts.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
    var contact = contacts[indexPath.row]
    
    if searchController.active && searchController.searchBar.text != "" {
      contact = filteredContacts[indexPath.row]
    } else {
      contact = contacts[indexPath.row]
    }
    
//    cell.fullName.text = contact.givenName
    
//    let phoneNum = contact.phoneNumbers.first
    
    

    
    if (contact.isKeyAvailable(CNContactGivenNameKey)) || (contact.isKeyAvailable(CNContactFamilyNameKey)) || (contact.isKeyAvailable(CNContactPhoneNumbersKey)) || (contact.isKeyAvailable(CNContactThumbnailImageDataKey)) || (contact.isKeyAvailable(CNContactImageDataAvailableKey)) {
      
      
      if contact.imageDataAvailable {
        print("ddddddddd")
        
        
//        if let big = contact.imageData {
//          let bigIm = UIImage(data: big)
//          print(big)
//        }
        
        if let small = contact.thumbnailImageData {
          let smallI = UIImage(data: small)
          
          print(smallI)
          
        }

      }
      

      
      
      let givenN = contact.givenName
      let familyName = contact.familyName
      let fullName = givenN + " " + familyName
      
      cell.fullName.text = fullName
      
      if let phoneNumber = contact.phoneNumbers.first {
        let phoneNumberString = phoneNumber.value as! CNPhoneNumber
        cell.phone.text = phoneNumberString.stringValue
        cell.phone.hidden = false 
      }
      
      
      if let thumbImage = contact.thumbnailImageData {
        
        cell.contactImage.image = UIImage(data:thumbImage)
        cell.contactImage.layer.cornerRadius = 25.0
        cell.contactImage.layer.masksToBounds = true
      }
      

    }
    
 
    return cell
  }
  
  @IBAction func addContact(sender: AnyObject) {
    
    let store = CNContactStore()
    let contact = CNMutableContact()
    //      contact.familyName = ""
    //      contact.givenName = ""
    //      let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: "301-555-1212"))
    //      contact.phoneNumbers = [homePhone]
    //      let controller = CNContactViewController(forUnknownContact: contact)
    //      let controller = CNContactViewController(forContact: contact)
    let controller = CNContactViewController(forNewContact: contact)
    
    
    controller.contactStore = store
    controller.delegate = self
//          self.presentViewController(controller, animated:true, completion:nil)
    self.navigationController?.pushViewController(controller, animated: true)
    self.tabBarController?.tabBar.hidden = true
  }
  
  // MARK:  UITableViewDelegate Methods
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  
  
  func filterContentForSearchText(searchText: String) {
    filteredContacts = contacts.filter({( contact : CNContact) -> Bool in
      return contact.givenName.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
  }
  
  
  
  func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
    
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.redColor()
    self.navigationController?.pushViewController(newVC, animated: true)
    
    print(contact)
    
  }
  
  
}

// MARK: - Extensions
// MARK: UISearchResultsUpdating Delegate
extension ContactsVC: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!)
  }
}

// MARK: UISearchResultsUpdating Delegate
extension ContactsVC: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

// MARK: CNContactViewControllerDelegate
extension ContactsVC: CNContactViewControllerDelegate {
  
  func contactViewController(vc: CNContactViewController, didCompleteWithContact con: CNContact?) {
    print(con)
    
    self.tabBarController?.tabBar.hidden = false
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func contactViewController(vc: CNContactViewController, shouldPerformDefaultActionForContactProperty prop: CNContactProperty) -> Bool {
    return false
  }
  
}

