//
//  LocationResponse.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 13/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

class LocationResponse: NSObject {
    var available: Bool?
    var question: String?
    var answerA: String?
    var answerB: String?
    var answerC: String?
    var answerD: String?
    
    override init() {
        super.init()
    }
    
    init?(dict: NSDictionary) {
        self.available = dict["locationAvailable"] as? Bool
        
        let questionObject = dict["question"] as! NSDictionary
        
        self.question = questionObject["question"] as? String
        
        let answers = questionObject["answers"] as! NSDictionary
        self.answerA = answers["A"] as? String
        self.answerB = answers["B"] as? String
        self.answerC = answers["C"] as? String
        self.answerD = answers["D"] as? String
    }
}
