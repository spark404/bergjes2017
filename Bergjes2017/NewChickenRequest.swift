//
//  NewChickenRequest.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 23/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import AWSLambda

class NewChickenRequest : LambdaBase {
    override init() {
        super.init()
    }
    
    func executeRequest(completionHandler: @escaping (_ response: NewChickenResponse) -> Void, failedHandler: @escaping (_ error: NSError) -> Void) {
        
        let jsonObject: [String: Any] = ["newChicken" : "true"]
        
        lambdaInvoker
            .invokeFunction("NewChickenRequest", jsonObject: jsonObject)
            .continueWith(block: {(task) -> AWSTask<AnyObject>! in
                if(task.isFaulted) {
                    let error: NSError = (task.error as NSError?)!;
                    failedHandler(error)
                    return nil
                }
                
                // Handle response in task.result
                guard let JSONDictionary = task.result as? NSDictionary else {
                    failedHandler(NSError(domain: "NewChickenRequest", code: 1, userInfo: nil))
                    return nil
                }
                
                let newChickenResponse = NewChickenResponse(dict: JSONDictionary)
                completionHandler(newChickenResponse!)
                return nil
            })
    }
    
}
