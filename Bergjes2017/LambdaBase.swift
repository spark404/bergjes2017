//
//  LambdaBase.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 13/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import AWSLambda

class LambdaBase: NSObject {
    let lambdaInvoker = AWSLambdaInvoker.default()
    
    override init() {
        
    }
}
