//
//  ResultViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 17/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

protocol ResultDismissDelegate {
    func resultDismissed() -> Void
}

class ResultViewController: UIViewController{
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultText: UILabel!
    
    var delegate: ResultDismissDelegate?
    
    var result: String?
    var resultMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (result == "WRONG") {
            resultImage.image = #imageLiteral(resourceName: "facepalm")
            resultText.text = resultMessage ?? "Jammer.. Jammer.. Jammer.."
        } else if (result == "CORRECT") {
            resultImage.image = #imageLiteral(resourceName: "welldone")
            resultText.text = resultMessage ?? "OK Dan! Best wel goed zeg maar!"
        } else if (result == "NEWLOCATION") {
            resultImage.image = #imageLiteral(resourceName: "questiondino")
            resultText.text = resultMessage ?? "Blijkbaar heb je een nieuwe vraag in de vragen lijst"
        }
        else {
            resultImage.image = #imageLiteral(resourceName: "grumpycat")
            resultText.text = resultMessage ?? "Uhmm.. niet precies wat we verwachten"
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.resultDismissed()
    }
    
}
