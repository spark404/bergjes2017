//
//  GrondstoffenController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 08/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class GrondstoffenController: UIViewController {
    @IBOutlet weak var resourcesTableView: UITableView!
    
    var resources: [Resource]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resourcesTableView.delegate = self
        resourcesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let spinnerController = SpinnerController(parentView: self.view)
        spinnerController.activateSpinner()
        
        let statusRequest = StatusRequest()
        statusRequest.executeRequest(completionHandler: { (response: StatusResponse) in
            self.resources = response.resourceList
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
                self.resourcesTableView.reloadData()
            }
        }) { (error: NSError) in
            print("Error while executing StatusRequest: \(error)")
            
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
            }
        }
    }
    
}

extension GrondstoffenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension GrondstoffenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResourceTableViewCell = self.resourcesTableView.dequeueReusableCell(withIdentifier: "resourceCell")! as! ResourceTableViewCell
        
        switch resources![indexPath.row].type! {
        case "EGG":
            cell.resourceDescription?.text = "Eieren"
            cell.resourceImage?.image = #imageLiteral(resourceName: "egg")
        case "FENCE":
            cell.resourceDescription?.text = "Gaas"
            cell.resourceImage?.image = #imageLiteral(resourceName: "fence")
        case "WOOD":
            cell.resourceDescription?.text = "Hout"
            cell.resourceImage?.image = #imageLiteral(resourceName: "wood")
        case "GRAIN":
            cell.resourceDescription?.text = "Graan"
            cell.resourceImage?.image = #imageLiteral(resourceName: "grain")
        case "BRICK":
            cell.resourceDescription?.text = "Stenen"
            cell.resourceImage?.image = #imageLiteral(resourceName: "brick")
        case "CHICKEN":
            cell.resourceDescription?.text = "Kippen"
            cell.resourceImage?.image = #imageLiteral(resourceName: "Chicken")
        default:
            cell.resourceDescription?.text = "Wut Wut Wut..."
        }
        
        cell.resourceCount?.text = "\(resources![indexPath.row].amount!)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.resources ?? []).count;
    }
}
