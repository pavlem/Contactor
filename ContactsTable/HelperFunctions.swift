//
//  HelperFunctions.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

import Foundation



func capitalizeFirstLetterInArrayOfStrings(strings: [String]) -> [String] {
  var capitalizedStrings = strings
  for (index, element) in strings.enumerate() {
    capitalizedStrings[index] = element.uppercaseFirst
  }
  return capitalizedStrings
}

func getInitialsFromArrayOfStrings(strings: [String]) -> [String] {
  var initials = strings
  initials = initials.unique
  initials = initials.sort() { $0 < $1 }
  return initials
}
