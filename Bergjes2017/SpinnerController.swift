//
//  SpinnerController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 14/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class SpinnerController: NSObject {
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var parentView: UIView!
    
    init(parentView: UIView) {
        self.parentView = parentView
    }
    

    func activateSpinner() {
        activityView.hidesWhenStopped = true
        activityView.color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        activityView.center = parentView.center
        activityView.startAnimating()
        
        parentView.addSubview(activityView)
    }
    
    func deactivateSpinner() {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }

}
