//
//  VragenViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 08/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class VragenViewController: UIViewController {
    @IBOutlet weak var questionsTableView: UITableView!
    
    var questions: [Question]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let spinnerController = SpinnerController(parentView: self.view)
        spinnerController.activateSpinner()
        
        let statusRequest = StatusRequest()
        statusRequest.executeRequest(completionHandler: { (response: StatusResponse) in
            self.questions = response.questionList
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
                self.questionsTableView.reloadData()
            }
        }) { (error: NSError) in
            print("Error while executing StatusRequest: \(error)")
            
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
            }
        }
    }
}

extension VragenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "questionDetail") as! QuestionDetailViewController
        controller.question = questions![indexPath.row]
        self.present(controller, animated: true)
    }
}

extension VragenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QuestionsTableViewCell = self.questionsTableView.dequeueReusableCell(withIdentifier: "questionCell")! as! QuestionsTableViewCell
        cell.questionText.text = questions![indexPath.row].question
        cell.questionImage.image = #imageLiteral(resourceName: "questionOpen")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.questions ?? []).count;
    }
}
