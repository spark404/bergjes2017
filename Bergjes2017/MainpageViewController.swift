//
//  MainpageViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 29/03/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import UIKit

class MainpageViewController: UIViewController {
    
    @IBOutlet var qrCode: UILabel?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.addObserver(self, selector: #selector(MainpageViewController.handleNotification), name: notificationName, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleNotification(withNotification notification : NSNotification) {
        DispatchQueue.main.async {
            self.qrCode?.text = notification.object as? String
            self.tabBarController?.selectedIndex = 0
        }

    }

}

