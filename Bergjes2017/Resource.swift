//
//  Resource.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 14/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

class Resource: NSObject {
    var type: String!
    var amount: Int!
    
    init?(type: String, amount: Int) {
        self.type = type
        self.amount = amount
    }
}
