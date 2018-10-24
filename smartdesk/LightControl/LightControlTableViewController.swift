//
//  LightControlTableViewController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/23/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class LightControlTableViewController: UITableViewController {
    let controller: LightController
    
    init(data: [LightControlOptions: [String]]) {
        controller = LightController(data: data)
        super.init(nibName: "LightControlTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alwaysBounceVertical = true
        
        tableView.register(UINib(nibName: "LightControlColorTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: LightControlColorTableViewCell.identifier)
        tableView.register(UINib(nibName: "DashboardHeaderTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: DashboardHeaderTableViewCell.identifier)
        tableView.register(UINib(nibName: "LightControlSliderTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: LightControlSliderTableViewCell.identifier)
    }
}


extension LightControlTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return controller.data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == controller.data.count - 1 {
            // dequeue the color controls
            let cell = tableView.dequeueReusableCell(withIdentifier: LightControlColorTableViewCell.identifier, for: indexPath)
            if let cell = cell as? LightControlColorTableViewCell {
                let colorStrings = controller.data[indexPath.section]
                // map the string to color, then remove all nil values
                cell.colors = colorStrings.map { controller.color(from: $0) }.compactMap { $0 }
                cell.colorStrings = colorStrings
            }
            return cell
        }
        // dequeue the sliders
        let cell = tableView.dequeueReusableCell(withIdentifier: LightControlSliderTableViewCell.identifier,
                                                 for: indexPath)
        if let cell = cell as? LightControlSliderTableViewCell {
            cell.setUp(upCommand: controller.data[indexPath.section].first ?? "",
                       downCommand: controller.data[indexPath.section].last ?? "",
                       function: LightControlSliderTableViewCell.LightSliderFunction(rawValue: indexPath.section)!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: DashboardHeaderTableViewCell.identifier)
        if let header = header as? DashboardHeaderTableViewCell {
            header.header.text = controller.sectionHeaders[section]
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
