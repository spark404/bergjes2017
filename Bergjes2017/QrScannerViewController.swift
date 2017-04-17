//
//  QrScannerViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 29/03/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import UIKit

class QrScannerViewController: UIViewController {
    @IBOutlet weak var errorMessage: UILabel!
    
    let qrscannerController = QrScannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrscannerController.delegate = self
        
        qrscannerController.checkCamera(completionHandler: {
            (Void) in
            DispatchQueue.main.async {
                self.qrscannerController.setupScanner(parentView: self.view)
            }
        }, failedHandler: {
           (Void) in
            self.errorMessage.text = "Zonder camera toegang wordt het dus niks, pas het even aan in settings.."
            })
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
        let controller = storyboard.instantiateViewController(withIdentifier: "wrongscan") as! WrongScanViewController
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
            DispatchQueue.main.async {
                if !response.available! {
                    self.wrongScan(message: "... maar volgens onze gegevens ben je hier al geweest deze ronde")
                    return
                }
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "result") as! ResultViewController
                controller.result = "NEWLOCATION"
                controller.resultMessage = "Nieuwe vraag; \"\(response.question!)\".\n\nDeze kan je beantwoorden via het \"vragen\" tabje.\n\n" +
                    "Deze locatie heeft op dit moment de grondstof \"\(response.resource?.getDecriptionForResource()! ?? "....")\""
                controller.delegate = self
                self.present(controller, animated: true)
            }
        }, failedHandler: {
            (error: NSError) -> Void in
            print("\(error)")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oeps", message: error.userInfo["errorMessage"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    self.qrscannerController.startSession()
                }))
                self.present(alert, animated: true)
            }
        })
    }
    
}

extension QrScannerViewController: ResultDismissDelegate {
    func resultDismissed() {
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = 3;
        }
    }
}

