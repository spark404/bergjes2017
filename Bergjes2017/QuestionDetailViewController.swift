//
//  QuestionDetailViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 15/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class QuestionDetailViewController: UIViewController {
    var question: Question?
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var answerTextA: UILabel!
    @IBOutlet weak var answerTextB: UILabel!
    @IBOutlet weak var answerTextC: UILabel!
    @IBOutlet weak var answerTextD: UILabel!
    
    @IBOutlet weak var scanAnswerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionText.text = question?.question
        answerTextA.text = question?.answerA
        answerTextB.text = question?.answerB
        answerTextC.text = question?.answerC
        answerTextD.text = question?.answerD
        
        if question?.answerStatus != "OPEN" {
            scanAnswerButton.isHidden = true
        }
    }
    
    @IBAction func scanButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "scanAnswer") as! ScanAnswerViewController
        controller.delegate = self
        self.present(controller, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension QuestionDetailViewController: AnswerScannedDelegate {
    func answerReceived(answerCode: String!) {
        let spinnerController = SpinnerController(parentView: self.view)
        DispatchQueue.main.async {
            spinnerController.activateSpinner()
        }

        let answerRequest = AnswerRequest(questionKey: self.question!.questionKey, answerKey: answerCode!)
        answerRequest.executeRequest(completionHandler: { (response) in
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
                self.handleAnswer(answerResponse: response)
            }
        }) { (error) in
            print("\(error)")
            
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
                let alert = UIAlertController(title: "Alert", message: error.userInfo["errorMessage"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default))
                self.present(alert, animated: true)
            }
        }
        
    }
    
    func handleAnswer(answerResponse: AnswerResponse!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "result") as! ResultViewController
        controller.result = answerResponse.answerStatus
        scanAnswerButton.isHidden = true;
        self.present(controller, animated: true)
    }
}
