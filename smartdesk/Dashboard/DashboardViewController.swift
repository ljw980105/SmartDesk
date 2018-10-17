//
//  DashboardViewController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, BLEManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    
    private let controller = DashboardController()
    private var signalStrengthTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "DashboardHeaderTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: DashboardHeaderTableViewCell.identifier)
        tableView.register(UINib(nibName: "SignalStrengthTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SignalStrengthTableViewCell.identifier)
        
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        signalStrengthTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { timer in
            BLEManager.current.readSignalStrength()
        }
        signalStrengthTimer?.tolerance = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BLEManager.current.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            tableViewWidth.constant = 768
        } else {
            tableViewWidth.constant = UIScreen.main.bounds.width
        }
    }
    
    // MARK: - BLEManagerDelegate
    
    func didReceiveError(error: BLEError?) {
        error?.showErrorMessage()
        dismiss(animated: true, completion: nil)
        signalStrengthTimer?.invalidate()
        BLEManager.current.delegate = nil
    }
    
    func didReceiveRSSIReading(reading: Int, status: String) {
        let indexPath = IndexPath(row: 0, section: controller.bleControls.count)
        let cell = tableView.cellForRow(at: indexPath) as? SignalStrengthTableViewCell
        cell?.strengthLabel.text = "Signal Strength: \(status) (\(reading)dBm)"
    }
    
    // MARK: - IBActions
    @IBAction func disconnectBLE(_ sender: UIBarButtonItem) {
        BLEManager.current.disconnect()
        dismiss(animated: true, completion: nil)
        BLEManager.current.delegate = nil
        signalStrengthTimer?.invalidate()
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.bleControls.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the last strength indicator cell
        if indexPath.section == controller.bleControls.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: SignalStrengthTableViewCell.identifier,
            for: indexPath) as? SignalStrengthTableViewCell
            return cell ?? UITableViewCell()
        }
        
        // dequeue the generic cell
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardSlidableTableViewCell.identifier)
        if let cell = cell as? DashboardSlidableTableViewCell {
            cell.controllableObject = controller.bleControls[indexPath.row]
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: DashboardHeaderTableViewCell.identifier)
        if let header = header as? DashboardHeaderTableViewCell {
            if section >= controller.bleControls.count { return nil }
            header.header.text = controller.bleControls[section].sectionHeader
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == controller.bleControls.count ? 0 : 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == controller.bleControls.count ? 40.0 : 80.0
    }
    
}

