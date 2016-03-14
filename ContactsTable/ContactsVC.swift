//  Created by Pavle Mijatovic on 2/26/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


struct CustomContact {
  var fullName : String?
  var phoneNumber : String?
  var imageData: NSData?
  
  init(fullName: String, phoneNumber: String) {
    self.fullName = fullName
    self.phoneNumber = phoneNumber
  }
}




class ContactsVC: UITableViewController, CNContactPickerDelegate {
  
  // MARK: - Properties
  let searchController = UISearchController(searchResultsController: nil)
  
//  var cnContacts = [CNContact]()
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
    getSystemContacs()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.hidden = false
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
  
  private func getSystemContacs() {
    
    var cnContacts = ContactsDAO.getAllContacts()
    
    for cnContact in cnContacts {
      cnContacts.append(cnContact)
    }
    
    extractPropertiesFromSystemContacts(cnContacts)
  }
  
  
  private func extractPropertiesFromSystemContacts(cnContacts: [CNContact]) {
    
    for cnContact in cnContacts {
      let givenN = cnContact.givenName
      let familyName = cnContact.familyName
      let fullName = givenN + " " + familyName
      var phoneNumberString = ""
      
      if let phoneNumber = cnContact.phoneNumbers.first {
        let phoneNumber = phoneNumber.value as! CNPhoneNumber
        phoneNumberString = phoneNumber.stringValue
      }
      
      contactsFullNames.append(fullName)
      
      var contact = CustomContact(fullName: fullName, phoneNumber: phoneNumberString)
      
      if let image = cnContact.thumbnailImageData {
        contact.imageData = image
      }
      
      contacts.append(contact)
    }
    
    
    for (index, element) in contactsFullNames.enumerate() {
      contactsFullNames[index] = element.uppercaseFirst
    }
    
    var initials = contactsFullNames.initials  // ["A", "B", "C", "D", "F"]
    initials = initials.unique
    initials = initials.sort() { $0 < $1 }
    contactsFullNames = contactsFullNames.sort() { $0 < $1 }
    self.contactsSectionTitles = initials
    
    for key in contactsSectionTitles {
      var tempContactsForKey = [CustomContact]()
      for contact in contacts {
        if key == contact.fullName?.first {
          tempContactsForKey.append(contact)
        }
      }
      
      contactsDictionary[key] = tempContactsForKey
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
  override func numberOfSectionsInTableView(tableView:UITableView)->Int {
    if searchController.active && searchController.searchBar.text != "" {
      print("searching")
      return 1
      
    }
    print("not searching")
    
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
    cell.phone.text = contact.phoneNumber
    
    if let thumbImage = contact.imageData {
      
      cell.contactImage.image = UIImage(data:thumbImage)
      cell.contactImage.layer.cornerRadius = 25.0
      cell.contactImage.layer.masksToBounds = true
    }
    
    
    
    
    return cell
  }
  
  @IBAction func addContact(sender: AnyObject) {
    
    let store = CNContactStore()
    let contact = CNMutableContact()
    let controller = CNContactViewController(forNewContact: contact)
    
    controller.contactStore = store
    controller.delegate = self
    self.navigationController?.pushViewController(controller, animated: true)
    self.tabBarController?.tabBar.hidden = true
  }
  
  // MARK:  UITableViewDelegate Methods
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    createActionSheet(indexPath)
  }
  
  
  
  func filterContentForSearchText(searchText: String) {
    //    filteredContacts = contacts.filter({( contact : CNContact) -> Bool in
    contactsFiltered = contacts.filter({( contact : CustomContact) -> Bool in
      
      //      return contact.givenName.lowercaseString.containsString(searchText.lowercaseString)
      return contact.fullName!.lowercaseString.containsString(searchText.lowercaseString)
      
    })
    tableView.reloadData()
  }
  
  
  
  func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
    
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.redColor()
    self.navigationController?.pushViewController(newVC, animated: true)
    
    print(contact)
    
  }
  
  
  private func sendSmsToContact(contact:CustomContact) {
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.redColor()
    
    self.navigationController?.pushViewController(newVC, animated: true)
    self.navigationItem.title = contact.fullName
    
    
    self.tabBarController?.tabBar.hidden = true
    
    print(contact.fullName)
  }
  
  private func callContact(contact:CustomContact) {
    
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.greenColor()
    self.navigationController?.pushViewController(newVC, animated: true)
    
    self.navigationItem.title = contact.fullName
    
    self.tabBarController?.tabBar.hidden = true
    
    print(contact.fullName)
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
    
    //
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

extension Array where Element: StringLiteralConvertible {
  var initials: [String] {
    return map{String(($0 as! String).characters.prefix(1))}
  }
}


extension Array where Element : Hashable {
  var unique: [Element] {
    return Array(Set(self))
  }
}

extension String {
  var first: String {
    return String(characters.prefix(1))
  }
  var last: String {
    return String(characters.suffix(1))
  }
  var uppercaseFirst: String {
    return first.uppercaseString + String(characters.dropFirst())
  }
}
