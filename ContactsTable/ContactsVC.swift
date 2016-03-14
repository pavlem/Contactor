//  Created by Pavle Mijatovic on 2/26/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


class ContactsVC: UITableViewController, CNContactPickerDelegate {
  
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
  private func capitalizeFirstLetterInArrayOfStrings(strings: [String]) -> [String] {
    var capitalizedStrings = strings
    for (index, element) in strings.enumerate() {
      capitalizedStrings[index] = element.uppercaseFirst
    }
    return capitalizedStrings
  }
  
  private func getInitialsFromArrayOfStrings(strings: [String]) -> [String] {
    var initials = strings
    initials = initials.unique
    initials = initials.sort() { $0 < $1 }
    return initials
  }
  
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
  
  // MARK: - Actions
  @IBAction func addContact(sender: AnyObject) {
    let controller = ContactsHandler.createContactVC()
    controller.delegate = self
    self.navigationController?.pushViewController(controller, animated: true)
    self.tabBarController?.tabBar.hidden = true
  }
  
  
  // MARK: - Delegates
  // MARK: UITableViewDataSource
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
    //    var contact = contacts[indexPath.row]
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

  
  // MARK:  UITableViewDelegate Methods
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    createActionSheet(indexPath)
  }
  
  func filterContentForSearchText(searchText: String) {
    contactsFiltered = contacts.filter({( contact : CustomContact) -> Bool in
      return contact.fullName!.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
  }
  
  func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.redColor()
    self.navigationController?.pushViewController(newVC, animated: true)
  }
  
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
  
  private func createActionSheet(indexPath: NSIndexPath) {
    
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

// MARK: - Extensions
// MARK: UISearchBarDelegate Delegate
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
    self.tabBarController?.tabBar.hidden = false
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func contactViewController(vc: CNContactViewController, shouldPerformDefaultActionForContactProperty prop: CNContactProperty) -> Bool {
    return false
  }
}