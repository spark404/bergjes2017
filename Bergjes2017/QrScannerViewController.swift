//
//  QrScannerViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 29/03/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import UIKit
import CoreLocation

class QrScannerViewController: UIViewController {
    @IBOutlet weak var errorMessage: UILabel!
    
    let qrscannerController = LocationAwareQrScannerController()
    
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

extension QrScannerViewController: LocationAwareQrCodeResultDelegate {
    func qrCodeFound(qrValue: String, location: CLLocation?) {
        if !qrValue.hasPrefix("http://www.fladderen.nl") {
            wrongScan(message: "... maar met deze QRCode kunnen we dus helemaal niks")
            return
        }
        
        guard let url = URL(string: qrValue) else {
            wrongScan(message: "... maar met deze QRCode kunnen we dus helemaal niks")
            return
        }
        
        let map = url.queryItems;
        let scanCode = map["bergjes2017"]!
        
        if (scanCode == "BETRADE") {
            let supplierId = map["from"]
            let suppliedResource = Resource(type: map["resource"]!, amount: Int(map["amount"]!)!)
            tradeRequest(supplierTeamId: supplierId!, suppliedResource: suppliedResource!)
        } else {
            locationRequest(locationCode: scanCode, currentLocation: location)
        }
        
    }
    
    func tradeRequest(supplierTeamId: String, suppliedResource: Resource) {
        let tradeRequest = TradeRequest(teamId: supplierTeamId, resource: suppliedResource)
        tradeRequest.executeRequest(completionHandler: { (response: TradeResponse) in
            DispatchQueue.main.async {
                // All went well, switch to resources tab
                self.tabBarController?.selectedIndex = 2
            }
        }) { (error: NSError) in
            print("\(error)")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oeps", message: error.userInfo["errorMessage"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    self.qrscannerController.startSession()
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    func locationRequest(locationCode: String, currentLocation: CLLocation?) {
        let locationRequest = LocationRequest(qrcodeText: locationCode)
        locationRequest.location = currentLocation
        
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
                "Deze locatie heeft op dit moment de grondstof \"\(response.resource?.getDescriptionForResource()! ?? "....")\""
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

