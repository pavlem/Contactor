//
//  Array+Extension.swift
//  ContactsTable
//
//  Created by Pavle Mijatovic on 3/14/16.
//  Copyright © 2016 Carnegie Technologies. All rights reserved.
//

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