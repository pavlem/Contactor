//
//  String+Extension.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

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