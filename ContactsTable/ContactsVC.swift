//  Created by Pavle Mijatovic on 2/26/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsVC: UITableViewController {
  
  // MARK: - Properties
  let searchController = UISearchController(searchResultsController: nil)
  
  var contacts = [CustomContact]()
  var contactsFiltered = [CustomContact]()
  
  var contactsSectionTitles = [String]()
  var contactsFullNames = [String]()
  var contactsDictionary = [String: [CustomContact]]()
  

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchController()
    setupTableView()
    getCustomContactsAndSortThem()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.hidden = false
  }
  
  // MARK: - Private
  private func getCustomContactsAndSortThem() {
    
    self.contacts = getSystemContactsAndExtractProperties(ContactsDAO.getAllContacts())
    
    for customContact in self.contacts {
      contactsFullNames.append(customContact.fullName!)
    }
    
    contactsFullNames = capitalizeFirstLetterInArrayOfStrings(contactsFullNames)
    contactsFullNames = contactsFullNames.sort() { $0 < $1 }
    contactsSectionTitles = getInitialsFromArrayOfStrings(contactsFullNames.initials)
    contactsDictionary = ContactsHandler.getContactsDictionary(forContactsSectionTitles: self.contactsSectionTitles, fromContactList: self.contacts)
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    definesPresentationContext = true
    searchController.dimsBackgroundDuringPresentation = false
    tableView.tableHeaderView = searchController.searchBar
    tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height);
  }
  
  private func setupTableView() {
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.tableFooterView!.hidden = true
    tableView.backgroundColor = UIColor.whiteColor()
  }
  
  private func getSystemContactsAndExtractProperties(cnContacts: [CNContact]) -> [CustomContact] {
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
  
  // MARK: - Public
  func filterContentForSearchText(searchText: String) {
    contactsFiltered = contacts.filter({( contact : CustomContact) -> Bool in
      return contact.fullName!.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
  }
  
  
  // MARK: - Actions
  @IBAction func addContact(sender: AnyObject) {
    let controller = ContactsHandler.createContactVC()
    controller.delegate = self
    self.navigationController?.pushViewController(controller, animated: true)
    self.tabBarController?.tabBar.hidden = true
  }
}