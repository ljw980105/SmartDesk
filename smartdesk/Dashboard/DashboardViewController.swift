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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "DashboardHeaderTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: DashboardHeaderTableViewCell.identifier)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
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
        BLEManager.current.delegate = nil
    }
    
    // MARK: - IBActions
    @IBAction func disconnectBLE(_ sender: UIBarButtonItem) {
        BLEManager.current.disconnect()
        dismiss(animated: true, completion: nil)
        BLEManager.current.delegate = nil
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.bleControls.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardSlidableTableViewCell.identifier)
        if let cell = cell as? DashboardSlidableTableViewCell {
            cell.controllableObject = controller.bleControls[indexPath.row]
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: DashboardHeaderTableViewCell.identifier)
        if let header = header as? DashboardHeaderTableViewCell {
            header.header.text = controller.bleControls[section].sectionHeader
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

