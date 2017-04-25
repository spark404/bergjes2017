//
//  TradeRequest.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 25/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import AWSLambda

class TradeRequest : LambdaBase {
    var teamId: String?
    var resource: Resource?;
    
    init(teamId: String, resource: Resource) {
        super.init()
        self.teamId = teamId
        self.resource = resource
    }
    
    func executeRequest(completionHandler: @escaping (_ response: TradeResponse) -> Void, failedHandler: @escaping (_ error: NSError) -> Void) {
        
        let jsonObject: [String: Any] = ["supplierId" : teamId!, "suppliedResource" : [ "resourceType" : resource!.type, "amount": resource!.amount]]
        
        lambdaInvoker
            .invokeFunction("TradeRequest", jsonObject: jsonObject)
            .continueWith(block: {(task) -> AWSTask<AnyObject>! in
                if(task.isFaulted) {
                    let error: NSError = (task.error as NSError?)!;
                    failedHandler(error)
                    return nil
                }
                
                // Handle response in task.result
                guard let JSONDictionary = task.result as? NSDictionary else {
                    failedHandler(NSError(domain: "TradeRequest", code: 1, userInfo: nil))
                    return nil
                }
                
                let tradeResponse = TradeResponse(dict: JSONDictionary)
                completionHandler(tradeResponse!)
                return nil
            })
    }
    
}
