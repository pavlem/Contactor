//  Created by Pavle Mijatovic on 2/26/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


struct contactCustom {
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
  var contacts = [CNContact]()
  //  var contactsWithSections = [CNContact]()
  //  var filteredContacts = [CNContact]()
  
  let searchController = UISearchController(searchResultsController: nil)
  
  
  var contactsLo = [contactCustom]()
  var filteredContacts = [contactCustom]()
  
  
  
  var contactSectionTitles = [String]()
  var contactNames = [String]()
  

  
  var dictPaja = [String: [contactCustom]]()
  
  
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchController()
    setupTableView()
    getUserData()
    
    //    alphabetiseContacts()
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
  
  private func getUserData() {
    
    let cnContacts = ContactsDAO.getAllContacts()
    
    for cnContact in cnContacts {
      self.contacts.append(cnContact)
    }
    
    
    
    
    for c in self.contacts {
      
      let givenN = c.givenName
      let familyName = c.familyName
      let fullName = givenN + " " + familyName
      var phoneNumberString = ""
      
      if let phoneNumber = c.phoneNumbers.first {
        let phoneNumber = phoneNumber.value as! CNPhoneNumber
        phoneNumberString = phoneNumber.stringValue
      }
      
      
      contactNames.append(fullName)
      
      
      var contact = contactCustom(fullName: fullName, phoneNumber: phoneNumberString)
      
      if let image = c.thumbnailImageData {
        contact.imageData = image
      }
      
      contactsLo.append(contact)
      
    }
    
    
    for (index, element) in contactNames.enumerate() {
      contactNames[index] = element.uppercaseFirst
    }
    
    var initials = contactNames.initials  // ["A", "B", "C", "D", "F"]
    initials = initials.unique
    initials = initials.sort() { $0 < $1 }
    contactNames = contactNames.sort() { $0 < $1 }
    
    
    self.contactSectionTitles = initials
    
    
  
    
    for key in contactSectionTitles {
      var tempContactsForKey = [contactCustom]()
      for contact in contactsLo {
        if key == contact.fullName?.first {
          tempContactsForKey.append(contact)
        }
      }
      
      dictPaja[key] = tempContactsForKey
    }
    
    print("sdfsdf")
  }
  
  
  //  private func alphabetiseContacts() {
  //
  //
  //
  //
  //
  //
  ////    self.contacts =  self.contacts.sort() { $0.givenName < $1.givenName }
  //
  //
  //
  //    for c in self.contacts {
  //
  //      let givenN = c.givenName
  //      let familyName = c.familyName
  //      let fullName = givenN + " " + familyName
  //      var phoneNumberString = ""
  //
  //      if let phoneNumber = c.phoneNumbers.first {
  //        let phoneNumber = phoneNumber.value as! CNPhoneNumber
  //        phoneNumberString = phoneNumber.stringValue
  //      }
  //
  //      var contact = contactCustom(fullName: fullName, phoneNumber: phoneNumberString)
  //
  //      if let image = c.thumbnailImageData {
  //        contact.imageData = image
  //      }
  //
  //      contactsLo.append(contact)
  //
  //    }
  //
  //
  //    print("fsdfsdfs")
  //
  //
  //  }
  
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
    
    return self.contactSectionTitles.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.active && searchController.searchBar.text != "" {
      return self.filteredContacts.count
    }
    
    
    
    
    let sectionTitle = contactSectionTitles[section]
    let sectionContacts = dictPaja[sectionTitle]!
    
    return sectionContacts.count
    
    
    
//    return self.contactsLo.count
    
    // Return the number of rows in the section.
//    NSString *sectionTitle = [animalSectionTitles objectAtIndex:section];
//    NSArray *sectionAnimals = [animals objectForKey:sectionTitle];
//    return [sectionAnimals count];
  }
  
  override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    return self.contactSectionTitles
  }
  
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    
    return contactSectionTitles[section]
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
    //    var contact = contacts[indexPath.row]
    var contact = contactsLo[indexPath.row]
    
    if searchController.active && searchController.searchBar.text != "" {
      contact = filteredContacts[indexPath.row]
    } else {
      
      
      
      //      NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section];
      //      NSArray *sectionAnimals = [animals objectForKey:sectionTitle];
      //      NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
      //      cell.textLabel.text = animal;
      //      cell.imageView.image = [UIImage imageNamed:[self getImageFilename:animal]];
      
      
      
      let sectionTitle = contactSectionTitles[indexPath.section]
      let sectionContacts = dictPaja[sectionTitle]!
      
      contact = sectionContacts[indexPath.row]
//    contact = sectionContacts![indexPath.row]
      
      
      
      
      //      contact = contacts[indexPath.row]
      //      contact = sectionContacts[indexPath.row]
      
    }
    
    
    
    //------------------------------------------------
    //    if (contact.isKeyAvailable(CNContactGivenNameKey)) || (contact.isKeyAvailable(CNContactFamilyNameKey)) || (contact.isKeyAvailable(CNContactPhoneNumbersKey)) || (contact.isKeyAvailable(CNContactThumbnailImageDataKey)) || (contact.isKeyAvailable(CNContactImageDataAvailableKey)) {
    //
    //
    //      if contact.imageDataAvailable {
    //        print("ddddddddd")
    //
    //        //        if let big = contact.imageData {
    //        //          let bigIm = UIImage(data: big)
    //        //          print(big)
    //        //        }
    //
    //        if let small = contact.thumbnailImageData {
    //          let smallI = UIImage(data: small)
    //          print(smallI)
    //        }
    //      }
    //
    //
    //
    //      let givenN = contact.givenName
    //      let familyName = contact.familyName
    //      let fullName = givenN + " " + familyName
    //
    //      cell.fullName.text = fullName
    //
    //      if let phoneNumber = contact.phoneNumbers.first {
    //        let phoneNumberString = phoneNumber.value as! CNPhoneNumber
    //        cell.phone.text = phoneNumberString.stringValue
    //        cell.phone.hidden = false
    //      }
    //
    //
    //      if let thumbImage = contact.thumbnailImageData {
    //
    //        cell.contactImage.image = UIImage(data:thumbImage)
    //        cell.contactImage.layer.cornerRadius = 25.0
    //        cell.contactImage.layer.masksToBounds = true
    //      }
    //
    //
    //      //------------------------------------------------
    //
    //
    //
    //    }
    
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
    
    createActionSheet(indexPath)
  }
  
  
  
  func filterContentForSearchText(searchText: String) {
    //    filteredContacts = contacts.filter({( contact : CNContact) -> Bool in
    filteredContacts = contactsLo.filter({( contact : contactCustom) -> Bool in
      
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
  
  
  private func sendSmsToContact(contact:contactCustom) {
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.redColor()
    
    self.navigationController?.pushViewController(newVC, animated: true)
    self.navigationItem.title = contact.fullName

    
    self.tabBarController?.tabBar.hidden = true

    print(contact.fullName)
  }
  
  private func callContact(contact:contactCustom) {
    
    let newVC = UIViewController()
    newVC.view.backgroundColor = UIColor.greenColor()
    self.navigationController?.pushViewController(newVC, animated: true)
    
    self.navigationItem.title = contact.fullName
    
    self.tabBarController?.tabBar.hidden = true

    print(contact.fullName)
  }
  
  
  private func createActionSheet(indexPath: NSIndexPath) {
    
    var contact = contactCustom(fullName: "", phoneNumber: "")
    
    if searchController.active && searchController.searchBar.text != "" {
      contact = filteredContacts[indexPath.row]
    } else {
      let sectionTitle = contactSectionTitles[indexPath.section]
      let sectionContacts = dictPaja[sectionTitle]!
      
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
//    print(contact.fullName)
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
