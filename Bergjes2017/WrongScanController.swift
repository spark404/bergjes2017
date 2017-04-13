//
//  WrongScanController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 10/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class WrongScanController: UIViewController {
    
    @IBOutlet var sorryMessage: UILabel?
    var message: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sorryMessage?.text = message ?? "... dit gaat em niet worden"
    }
    
    @IBAction func handleCloseButton() {
        self.dismiss(animated: true)
    }
}
