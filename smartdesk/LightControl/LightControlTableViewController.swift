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
    
    init(data: [LightControlOptions: String]) {
        controller = LightController(data: data)
        super.init(nibName: "LightControlTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alwaysBounceVertical = true
        
        tableView.register(UINib(nibName: "LightControlColorTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: LightControlColorTableViewCell.identifier)
        tableView.register(UINib(nibName: "DashboardHeaderTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: DashboardHeaderTableViewCell.identifier)
        tableView.register(UINib(nibName: "LightControlSliderTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: LightControlSliderTableViewCell.identifier)
        
        addColorPopover()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let brightness = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LightControlSliderTableViewCell)?.lightSlider.value,
             let warmth = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? LightControlSliderTableViewCell)?.lightSlider.value {
            controller.databaseManager.set(brightness: brightness, colorTemeprature: warmth)
        }
    }
    
    // MARK: - Private Helper
    
    private func addColorPopover() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More Colors", style: .plain,
                                                            target: self, action: #selector(showColorPicker))
    }
    
    @objc private func showColorPicker() {
        let colorPicker = ColorPickerViewController()
        colorPicker.modalTransitionStyle = .crossDissolve
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // customize different sizes for color picker depending on the devices they are using
        let size: Int
        if UIDevice.current.userInterfaceIdiom == .phone {
            size = Int(view.bounds.width * 0.9)
        } else { // on an ipad
            size = Int(view.bounds.width * 0.5)
        }
        
        colorPicker.preferredContentSize = CGSize(width: size, height: size)
        colorPicker.didSelectColor = { [weak self] color in
            let cmd = self?.controller.data.last?.first ?? ""
            BLEManager.current.send(colorCommand: cmd, color: color)
        }
        colorPicker.popoverPresentationController?.delegate = self
        present(colorPicker, animated: true, completion: nil)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: LightControlColorTableViewCell.identifier,
                                                     for: indexPath)
            if let cell = cell as? LightControlColorTableViewCell {
                cell.colors = controller.colors
                cell.colorCommand = controller.data[indexPath.section].first ?? ""
            }
            return cell
        }
        // dequeue the sliders
        let cell = tableView.dequeueReusableCell(withIdentifier: LightControlSliderTableViewCell.identifier,
                                                 for: indexPath)
        if let cell = cell as? LightControlSliderTableViewCell {
            cell.setUp(upCommand: controller.data[indexPath.section].first ?? "",
                       downCommand: controller.data[indexPath.section].last ?? "",
                       function: LightSliderFunction(rawValue: indexPath.section)!,
                       databaseManager: controller.databaseManager)
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
}

extension LightControlTableViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
