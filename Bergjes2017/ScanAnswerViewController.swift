//
//  ScanAnswerViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 16/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

protocol AnswerScannedDelegate {
    func answerReceived(answerCode: String!)
}

class ScanAnswerViewController: UIViewController {
    let qrScannerController = QrScannerController()
    
    @IBOutlet weak var previewView: UIView!
    
    var delegate: AnswerScannedDelegate?
    
    override func viewDidLoad() {
        qrScannerController.delegate = self
        qrScannerController.setupScanner(parentView: previewView)
        qrScannerController.startSession()
    }
    
    @IBAction func canceButton(_ sender: Any) {
        qrScannerController.stopSession()
        self.dismiss(animated: true)
    }
    
    func wrongScan(message: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "wrongscan") as! WrongScanViewController
        controller.message = message;
        self.present(controller, animated: true, completion: nil)
    }

}

extension ScanAnswerViewController: QrCodeResultDelegate {
    func qrCodeFound(qrValue: String) {
        DispatchQueue.main.async {
            self.qrScannerController.stopSession()
            
            if !qrValue.hasPrefix("http://www.fladderen.nl") {
                self.wrongScan(message: "... maar met deze QRCode kunnen we dus helemaal niks")
                return
            }
            
            guard let url = URL(string: qrValue) else {
                self.wrongScan(message: "... maar met deze QRCode kunnen we dus helemaal niks")
                return
            }
            
            let map = url.queryItems;
            let value = map["bergjes2017"]!
            
            if !value.hasPrefix("BEAN0") {
                self.wrongScan(message: "... maar dit lijkt geen geldig antwoord")
                return
            }
            
            let index = value.index(value.startIndex, offsetBy: 5)
            let answer = value.substring(from: index)
            
            self.delegate?.answerReceived(answerCode: answer)
            self.dismiss(animated: true)
        }
    }
}
