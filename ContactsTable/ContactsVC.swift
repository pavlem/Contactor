//  Created by Pavle Mijatovic on 2/26/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import UIKit

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
    getContactsAndSortThem()
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
  
  private func setupTableView() {
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.tableFooterView!.hidden = true
    tableView.backgroundColor = UIColor.whiteColor()
  }
    

  // MARK: - Actions
  @IBAction func addContact(sender: AnyObject) {
    let controller = ContactsHandler.createContactVC()
    controller.delegate = self
    self.navigationController?.pushViewController(controller, animated: true)
    self.tabBarController?.tabBar.hidden = true
  }
}