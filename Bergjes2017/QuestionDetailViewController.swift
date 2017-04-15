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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionText.text = question?.question
        answerTextA.text = question?.answerA
        answerTextB.text = question?.answerB
        answerTextC.text = question?.answerC
        answerTextD.text = question?.answerD
        
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
