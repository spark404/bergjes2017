//
//  MainpageViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 29/03/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import UIKit

class MainpageViewController: UIViewController {

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var roundEnd: UILabel!
    @IBOutlet weak var roundName: UILabel!
    @IBOutlet weak var gameExplanation: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameExplanation.isHidden = true
        
        // var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Scroll to top
        gameExplanation.scrollRangeToVisible(NSRange(location:0, length:0))
        
        let spinnerController = SpinnerController(parentView: self.view)
        spinnerController.activateSpinner()
        
        let statusRequest = StatusRequest()
        statusRequest.executeRequest(completionHandler: { (response: StatusResponse) in
            
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
                
                if (!response.teamActive!) {
                    self.wrongScan(message: "Dit team is nog niet actief, neem contact op met de spel leiding. Jullie meld code is : \(response.teamId!)")
                    return
                }
                
                self.gameExplanation.isHidden = false
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                self.roundEnd.text = formatter.string(from: response.roundExpiry!)
                self.roundName.text = self.getRoundName(currentRound: response.activeRound)
                self.teamName.text = response.teamName
            }
        }) { (error: NSError) in
            print("Error while executing StatusRequest: \(error)")
            
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
                ErrorController(parentViewController: self, error: error).displayError()
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRoundName(currentRound: String?) -> String {
        switch currentRound! {
        case "round1":
            return "Ronde 1"
        case "round2":
            return "Ronde 2"
        case "round3":
            return "Ronde 3"
        default:
            return "Onbekend"
        }
    }
    
    func wrongScan(message: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "wrongscan") as! WrongScanViewController
        controller.message = message;
        self.present(controller, animated: true, completion: nil)
    }
    
}

