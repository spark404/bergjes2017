//
//  MainpageViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 29/03/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import UIKit

class MainpageViewController: UIViewController {

    @IBOutlet weak var roundEnd: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let spinnerController = SpinnerController(parentView: self.view)
        spinnerController.activateSpinner()
        
        let statusRequest = StatusRequest()
        statusRequest.executeRequest(completionHandler: { (response: StatusResponse) in
            
            DispatchQueue.main.async {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                self.roundEnd.text = formatter.string(from: response.roundExpiry!)
                
                spinnerController.deactivateSpinner()
            }
        }) { (error: NSError) in
            print("Error while executing StatusRequest: \(error)")
            
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
    }
    
}

