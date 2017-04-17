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
    var resource: Resource?
    
    override init() {
        super.init()
    }
    
    init?(dict: NSDictionary) {
        self.available = dict["locationAvailable"] as? Bool
        
        if let questionObject = dict["question"] {
            let questionDict = questionObject as! NSDictionary
            self.question = questionDict["question"] as? String
            
            if let answers = questionDict["answers"] {
                let answersDict = answers as! NSDictionary
                self.answerA = answersDict["A"] as? String
                self.answerB = answersDict["B"] as? String
                self.answerC = answersDict["C"] as? String
                self.answerD = answersDict["D"] as? String
            }
        }
        
        if let resourceObject = dict["resource"] {
            let resourceItem = resourceObject as! NSDictionary
            self.resource = Resource(type: (resourceItem["resourceType"] as? String)!, amount: 0)
        }
        
    }
}
