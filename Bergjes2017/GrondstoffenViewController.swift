//
//  GrondstoffenController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 08/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import UIKit

class GrondstoffenViewController: UIViewController {
    @IBOutlet weak var resourcesTableView: UITableView!
    @IBOutlet weak var newChickenButton: UIButton!
    
    var resources: [Resource]?
    var teamIdentifier: String?
    
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
            self.teamIdentifier = response.teamId
            DispatchQueue.main.async {
                self.resourcesTableView.reloadData()
                self.newChickenButton!.isEnabled = self.chickenPossible();
                spinnerController.deactivateSpinner()
            }
        }) { (error: NSError) in
            DispatchQueue.main.async {
                spinnerController.deactivateSpinner()
                
                let alert = UIAlertController(title: "Alert", message: error.userInfo["errorMessage"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    func chickenPossible() -> Bool {
        let grainAmount = findResourceByType(resourceType: "GRAIN")?.amount
        let woodAmount = findResourceByType(resourceType: "WOOD")?.amount
        let fenceAmount = findResourceByType(resourceType: "FENCE")?.amount
        let eggAmount = findResourceByType(resourceType: "EGG")?.amount
        
        if (eggAmount! >= 1 && woodAmount! >= 2 && fenceAmount! >= 3 && grainAmount! >= 5) {
            return true;
        }
        
        return false;
    }
    
    func findResourceByType(resourceType: String) -> Resource? {
        for resource in self.resources! {
            if (resource.type == resourceType) {
                return resource
            }
        }
        return nil;
    }
    
    @IBAction func newChickenSelected(_ sender: Any) {
        if (chickenPossible()) {
            let spinnerController = SpinnerController(parentView: self.view)
            DispatchQueue.main.async {
                spinnerController.activateSpinner()
            }
            let request = NewChickenRequest()
            request.executeRequest(completionHandler: { (response) in
                DispatchQueue.main.async {
                    spinnerController.deactivateSpinner()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "newchicken") as! NewChickenViewController
                    self.present(controller, animated: true)
                }
            }, failedHandler: { (error) in
                print("\(error)")
                DispatchQueue.main.async {
                    spinnerController.deactivateSpinner()
                    let errorMessagee = error.userInfo["errorMessage"] ?? error.userInfo["Message"] ?? "Onbekende fout"
                    let alert = UIAlertController(title: "Oeps", message: errorMessagee as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true)
                }
            })
        }
    }
    
    func getResourcesForSection(section: Int) -> [Resource] {
        return self.resources?.filter({ (res) -> Bool in
            if (section == 0) {
                return !(res.type == "BRICK" || res.type == "CHICKEN")
            } else if (section == 1) {
                return res.type == "BRICK"
            } else if (section == 2) {
                return res.type == "CHICKEN"
            }
            return false;
        }) ?? []
    }
    
    func getResourceForIndexPath(indexPath: IndexPath) -> Resource? {
        let resourceList = getResourcesForSection(section: indexPath.section)
        if (resourceList.indices.contains(indexPath.row)) {
            return resourceList[indexPath.row]
        } else {
            return nil
        }
    }
    
}

extension GrondstoffenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "trade") as! TradeViewController
        controller.resource = getResourceForIndexPath(indexPath: indexPath)
        controller.teamIdentifier = self.teamIdentifier
        self.present(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.section != 2) {
            if ((getResourceForIndexPath(indexPath: indexPath)?.amount)! > 0) {
                return indexPath
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension GrondstoffenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResourceTableViewCell = self.resourcesTableView.dequeueReusableCell(withIdentifier: "resourceCell")! as! ResourceTableViewCell
        
        let resourceList = getResourcesForSection(section: indexPath.section)
        
        switch resourceList[indexPath.row].type! {
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
            cell.resourceDescription?.text = "Bakstenen"
            cell.resourceImage?.image = #imageLiteral(resourceName: "brick")
        case "CHICKEN":
            cell.resourceDescription?.text = "Kippen"
            cell.resourceImage?.image = #imageLiteral(resourceName: "Chicken")
        default:
            cell.resourceDescription?.text = "Wut Wut Wut..."
        }
        cell.resourceCount?.text = "\(resourceList[indexPath.row].amount!)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getResourcesForSection(section: section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Grondstoffen"
        case 1:
            return "Overige"
        case 2:
            return "Kippen"
        default:
            return "..."
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
}
