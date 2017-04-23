//
//  ErrorController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 23/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class ErrorController: NSObject {
    var parentViewController: UIViewController!
    var error: NSError!
    
    init (parentViewController: UIViewController, error: NSError) {
        self.parentViewController = parentViewController
        self.error = error
    }
    
    func displayError() {
        let errorMessage = error.userInfo["errorMessage"] ?? error.userInfo["Message"] ?? "Onbekende fout"
        let alert = UIAlertController(title: "Oeps", message: errorMessage as? String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        parentViewController.present(alert, animated: true)
    }
}
