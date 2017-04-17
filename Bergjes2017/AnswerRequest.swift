//
//  AnswerRequest.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 17/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import AWSLambda

class AnswerRequest: LambdaBase {
    var questionKey: String
    var answerKey: String

    init(questionKey: String, answerKey: String) {
        self.questionKey = questionKey
        self.answerKey = answerKey;
        
        super.init()
    }
    
    func executeRequest(completionHandler: @escaping (_ response: AnswerResponse) -> Void, failedHandler: @escaping (_ error: NSError) -> Void) {
        
        let jsonObject: [String: Any] = ["questionKey": questionKey, "answer": answerKey]
        
        lambdaInvoker
            .invokeFunction("ScannedAnswerRequest", jsonObject: jsonObject)
            .continueWith { (task) -> AWSTask<AnyObject>! in
                if(task.isFaulted) {
                    let error: NSError = (task.error as NSError?)!;
                    failedHandler(error)
                    return nil
                }
                
                // Handle response in task.result
                guard let JSONDictionary = task.result as? NSDictionary else {
                    failedHandler(NSError(domain: "AnswerRequest", code: 1, userInfo: nil))
                    return nil
                }
                
                let answerResponse = AnswerResponse(dict: JSONDictionary)
                completionHandler(answerResponse!)
                return nil
        }
        
    }
}
