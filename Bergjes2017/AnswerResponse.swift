//
//  AnswerResponse.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 17/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

class AnswerResponse: NSObject {
    var answerStatus: String?
    
    override init() {
        super.init()
    }
    
    init?(dict: NSDictionary) {
        self.answerStatus = dict["answerStatus"] as? String
    }
}
