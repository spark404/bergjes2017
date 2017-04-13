//
//  QrScannerViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 29/03/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import UIKit

class QrScannerViewController: UIViewController {
    
    let qrscannerController = QrScannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrscannerController.setupScanner(parentView: self.view)
        qrscannerController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrscannerController.startSession()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrscannerController.stopSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wrongScan(message: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "wrongscan") as! WrongScanController
        controller.message = message;
        self.present(controller, animated: true, completion: nil)
    }

}

extension QrScannerViewController: QrCodeResultDelegate {
    func qrCodeFound(qrValue: String) {
        if !qrValue.hasPrefix("http://www.fladderen.nl") {
            wrongScan(message: "... maar met deze QRCode kunnen we dus helemaal niks")
            return
        }
        
        guard let url = URL(string: qrValue) else {
            wrongScan(message: "... maar met deze QRCode kunnen we dus helemaal niks")
            return
        }
        
        let map = url.queryItems;
        
        let locationRequest = LocationRequest(qrcodeText: map["bergjes2017"]!)
        locationRequest.executeRequest(completionHandler: {
            (response: LocationResponse) -> Void in
            
            if !response.available! {
                DispatchQueue.main.async {
                    self.wrongScan(message: "... maar volgens onze gegevens ben je hier al geweest deze ronde")
                }
                return
            }
            
            let notificationName = Notification.Name("NotificationIdentifier")
            NotificationCenter.default.post(name: notificationName, object: response.question)
        }, failedHandler: {
            (error: NSError) -> Void in
            print("\(error)")
        })
    }
    
}

