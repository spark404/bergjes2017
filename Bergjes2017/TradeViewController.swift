//
//  TradeViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 23/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class TradeViewController: UIViewController {
    
    var resource: Resource?
    var teamIdentifier: String?
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountSlider: UISlider!
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountSlider.setValue(1, animated: false)
        amountSlider.minimumValue = Float(1);
        amountSlider.maximumValue = Float(resource!.amount);
        let current = Int(self.amountSlider.value)
        let description = self.resource!.getDescriptionForResource()!
        
        amountLabel.text = "\(current)x \(description)"
    }
    
    @IBAction func generateQR(_ sender: Any) {
        let prefix = "http://www.fladderen.nl?bergjes2017=BETRADE"
        let teamId = teamIdentifier!
        let tradeResource = self.resource!.type!
        let tradeAmount = Int(self.amountSlider.value)
        
        qrImageView.image = self.generateQRCode(from: "\(prefix)&from=\(teamId)&resource=\(tradeResource)&amount=\(tradeAmount)")
        self.qrImageView.isHidden = false
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func adjustAmount(_ sender: UISlider) {
        self.qrImageView.isHidden = true
        sender.setValue(sender.value.rounded(.toNearestOrAwayFromZero), animated: true)
        let current = Int(self.amountSlider.value)
        let description = self.resource!.getDescriptionForResource()!

        self.amountLabel.text = "\(current)x \(description)"
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
