//
//  CallsVC.swift
//  SatBridge
//
//  Created by Pavle Mijatovic on 2/26/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


class CallListVC: UITableViewController, CNContactPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: - Properties
  var contacts = [Contact]()
  var filteredContacts = [Contact]()
  let searchController = UISearchController(searchResultsController: nil)

  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setupSearchController()
    setupTableView()
    getUserData()
    
//    imagePicker =  UIImagePickerController()
//    imagePicker.delegate = self
//    imagePicker.sourceType = .Camera
//    self.presentViewController(imagePicker, animated: true, completion: nil)
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
    getUserDataFromServer()
  }
  
  private func getMOCData() {
    
  }
  
  private func getUserDataFromServer() {
    
    let requestURL: NSURL = NSURL(string: usersReqUrlString)!
    let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
    let sesionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    sesionConfig.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
    let session = NSURLSession(configuration: sesionConfig)
    let task = session.dataTaskWithRequest(urlRequest) {
      (data, response, error) -> Void in
      
      let httpResponse = response as! NSHTTPURLResponse
      let statusCode = httpResponse.statusCode
      
      if (statusCode == 200) {
        
        do{
          
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          
          let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
          
          if let usersJson = json as? [[String: AnyObject]] {
            for user in usersJson {
              
              if let _ = user["id"] as? Int? {
                if let name = user["name"] as? String {
                  if let email = user["email"] as? String {
                    if let company = user["company"] as? [String : AnyObject]  {
                      if let _ = company["catchPhrase"] as? String {
                        let contact = Contact(firstName: name, lastName: name, email: email)
                        
                        self.contacts.append(contact)
                        
                      }
                    }
                  }
                }
              }
            }
            
            
            dispatch_async(dispatch_get_main_queue(), {
              self.tableView.reloadData()
            })
          }
          
        } catch {
          print("Error with Json: \(error)")
          
        }
      }
    }
    
    task.resume()
  }
  
  
  private func setupTableView() {
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.tableFooterView!.hidden = true
    tableView.backgroundColor = UIColor.whiteColor()
  }
  
  private func filterContentForSearchText(searchText: String) {
    filteredContacts = contacts.filter({( contact : Contact) -> Bool in
      return contact.firstName!.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
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
    let cell = tableView.dequeueReusableCellWithIdentifier("CallCell", forIndexPath: indexPath) as! CallCell
    var contact = contacts[indexPath.row]
    
    if searchController.active && searchController.searchBar.text != "" {
      contact = filteredContacts[indexPath.row]
    } else {
      contact = contacts[indexPath.row]
    }
    
    
    cell.firstName.text = contact.firstName
    cell.lastName.text = contact.lastName
    cell.email.text = contact.email
    
    return cell
  }
  
   // MARK:  UITableViewDelegate Methods
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    
    
    
    
    
    createActionSheet(indexPath)
    
    
    
  }
  
  
  
  private func createActionSheet(indexPath: NSIndexPath) {
    
    print(indexPath.section)
    print(indexPath.row)

    
  }
  
  
  
  
  
  
}

// MARK: - Extensions
// MARK: UISearchResultsUpdating Delegate
extension CallListVC: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!)
  }
}

// MARK: UISearchResultsUpdating Delegate
extension CallListVC: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
