//
//  StatusResponse.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 14/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

class StatusResponse: NSObject {
    var teamActive: Bool?
    var activeRound: String?
    var roundExpiry: Date?
    var resourceList: [Resource] = []
    var questionList: [Question] = []
    var teamName: String?
    var teamId: String?
    
    override init() {
        super.init()
    }
    
    init?(dict: NSDictionary) {
        self.activeRound = dict["activeRound"] as? String
        self.teamActive = dict["teamActive"] as? Bool
        self.teamName = dict["teamName"] as? String
        self.teamId = dict["teamId"] as? String
        
        if let timestamp = dict["roundExpiry"] {
            self.roundExpiry = Date(timeIntervalSince1970: TimeInterval(timestamp as! Int))
        }
        
        let resources = dict["resourceList"] as! [NSDictionary]
        for resourceItem in resources  {
            let type: String = resourceItem["resourceType"] as! String!
            let amount: Int = resourceItem["amount"] as! Int!
            let resource = Resource(type: type, amount: amount)
            resourceList.append(resource!)
        }

        let questions = dict["activeQuestions"] as! [NSDictionary]
        for questionItem in questions  {
            let questionText: String = questionItem["question"] as! String!
            let questionKey: String = questionItem["questionKey"] as! String!
            let answers: NSDictionary = questionItem["answers"] as! NSDictionary!
            let answerA: String = answers["A"] as! String!
            let answerB: String = answers["B"] as! String!
            let answerC: String = answers["C"] as! String!
            let answerD: String = answers["D"] as! String!
            let answerStatus: String = questionItem["answerStatus"] as! String!
            
            let question = Question(questionKey: questionKey, question: questionText, answerA: answerA, answerB: answerB, answerC: answerC, answerD: answerD, answerStatus: answerStatus)
            questionList.append(question!)
        }
    }
}
