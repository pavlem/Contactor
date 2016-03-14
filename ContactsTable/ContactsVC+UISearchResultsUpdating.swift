//
//  ContactsVC+UISearchResultsUpdating.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import Foundation
import UIKit

extension ContactsVC: UISearchResultsUpdating {
  
  // MARK: - UISearchResultsUpdating
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
  
  // MARK: - Public
  func filterContentForSearchText(searchText: String) {
    contactsFiltered = contacts.filter({( contact : CustomContact) -> Bool in
      return contact.fullName!.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
  }
}