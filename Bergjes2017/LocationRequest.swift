//
//  LocationRequest.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 13/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import AWSLambda
import CoreLocation

class LocationRequest: LambdaBase {
    var qrcodeText: String
    var location: CLLocation?
    
    init(qrcodeText: String) {
        self.qrcodeText = qrcodeText
        
        super.init()
    }
    
    func executeRequest(completionHandler: @escaping (_ response: LocationResponse) -> Void, failedHandler: @escaping (_ error: NSError) -> Void) {
        
        var jsonObject: [String: Any] = ["locationCode" : qrcodeText]
        if ((location) != nil) {
            jsonObject = ["locationCode" : qrcodeText, "latitude" : location!.coordinate.latitude, "longitude": location!.coordinate.longitude, "accuracy": location!.horizontalAccuracy]
        }
        
        lambdaInvoker
            .invokeFunction("ScannedLocationRequest", jsonObject: jsonObject)
            .continueWith(block: {(task) -> AWSTask<AnyObject>! in
                if(task.isFaulted) {
                    let error: NSError = (task.error as NSError?)!;
                    failedHandler(error)
                    return nil
                }
                
                // Handle response in task.result
                guard let JSONDictionary = task.result as? NSDictionary else {
                    failedHandler(NSError(domain: "LocationRequest", code: 1, userInfo: nil))
                    return nil
                }
                
                let locationResponse = LocationResponse(dict: JSONDictionary)
                completionHandler(locationResponse!)
                return nil
            })
    }

}
