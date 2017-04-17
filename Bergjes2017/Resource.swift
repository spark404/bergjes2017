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
    
    func getDecriptionForResource() -> String! {
        switch self.type {
        case "EGG":
            return "Ei"
        case "WOOD":
            return "Hout"
        case "FENCE":
            return "Gaas"
        case "CHICKEN":
            return "Kip"
        case "GRAIN":
            return "Graan"
        case "ROCK":
            return "Steen"
        default:
            return "Iets dat nog geen naam heeft."
        }
    }
}
