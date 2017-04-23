//
//  StatusRequest.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 14/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import AWSLambda

class StatusRequest: LambdaBase {
    
    func executeRequest(completionHandler: @escaping (_ response: StatusResponse) -> Void, failedHandler: @escaping (_ error: NSError) -> Void) {
        
        let jsonObject: [String: Any] = ["deviceIndentifier" : UIDevice.current.identifierForVendor!.uuidString]
        
        lambdaInvoker
            .invokeFunction("StatusRequest", jsonObject: jsonObject)
            .continueWith(block: {(task) -> AWSTask<AnyObject>! in
                if(task.isFaulted) {
                    let error: NSError = (task.error as NSError?)!;
                    failedHandler(error)
                    return nil
                }
                
                // Handle response in task.result
                guard let JSONDictionary = task.result as? NSDictionary else {
                    failedHandler(NSError(domain: "StatusRequest", code: 1, userInfo: nil))
                    return nil
                }
                
                let statusResponse = StatusResponse(dict: JSONDictionary)
                completionHandler(statusResponse!)
                return nil
            })
    }
    
}
