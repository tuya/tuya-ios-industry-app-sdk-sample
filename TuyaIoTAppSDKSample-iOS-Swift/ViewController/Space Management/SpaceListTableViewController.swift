//
//  SpaceListTableViewController.swift
//  TuyaIoTAppSDK
//
//  Copyright (c) 2014-2024 Tuya Inc. (https://developer.tuya.com/)

import Foundation
import IndustrySpaceKit

class SpaceListTableViewController: UITableViewController {
    
    var spaceList = [ISpace]()

    var parentSpaceID: String?
    var parentSpaceName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let parentSpaceName = parentSpaceName {
            navigationItem.title = parentSpaceName
        }
        
        requestSpaceList(parentID: parentSpaceID)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "space-list-cell", for: indexPath)
        let space = spaceList[indexPath.row]

        cell.textLabel?.text = space.spaceName
        cell.detailTextLabel?.text = "sub space count \(space.currentSubSpaceNum), device count \(space.currentSpaceDeviceNum)"
        
        if (space.currentSubSpaceNum > 0) {
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .disclosureIndicator

        }else{
            cell.textLabel?.textColor = UIColor.lightGray
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let space = spaceList[indexPath.row]
        if (space.currentSubSpaceNum == 0) {return}
        
        let vc = storyboard!.instantiateInitialViewController() as! SpaceListTableViewController
        vc.parentSpaceID = spaceList[indexPath.row].spaceId
        vc.parentSpaceName = spaceList[indexPath.row].spaceName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func requestSpaceList(parentID: String? = nil) {
        SpaceService.shared.subSpaces(spaceId: parentID) {[weak self] spaces in
            guard let self = self else { return }
            self.spaceList.append(contentsOf: spaces)
            self.tableView.reloadData()
        } failure: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }

}

