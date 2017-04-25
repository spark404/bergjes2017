//
//  TradeResponse.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 25/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

class TradeResponse: NSObject {
    var resource: Resource?
    
    override init() {
        super.init()
    }
    
    init?(dict: NSDictionary) {
        // self.resource = dict["success"] as? Bool
    }
}
