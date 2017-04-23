//
//  NewChickenResponse.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 23/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

class NewChickenResponse: NSObject {
    var success: Bool?
    
    override init() {
        super.init()
    }
    
    init?(dict: NSDictionary) {
        self.success = dict["success"] as? Bool
    }
}
