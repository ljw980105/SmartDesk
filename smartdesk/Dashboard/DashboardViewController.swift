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
    @IBOutlet weak var signalStrengthItem: UIBarButtonItem!
    
    private let controller = DashboardController()
    private var signalStrengthTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "DashboardHeaderTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: DashboardHeaderTableViewCell.identifier)
        
        
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
        navigationController?.navigationBar.barStyle = .black
        BLEManager.current.delegate = self
        if UserDefaults.isTransitionAnimationNeeded {
            tableView.backgroundColor = UIColor.themeColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.isTransitionAnimationNeeded {
            UserDefaults.setTransitionAnimationNotNeeded()
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut],
                           animations: { [weak self] in
                self?.tableView.backgroundColor = UIColor.white
                }, completion: { [weak self] _ in
                    guard let strongSelf = self else { return }
                    strongSelf.controller.bleControls = strongSelf.controller.controls
                    strongSelf.tableView.reloadData()
            })
        }
    }
    
    // MARK: - BLEManagerDelegate
    
    func didReceiveError(error: BLEError?) {
        dismiss(animated: true) {
            error?.showErrorMessage()
        }
        signalStrengthTimer?.invalidate()
        BLEManager.current.delegate = nil
    }
    
    func didReceiveRSSIReading(reading: Int, status: String) {
        signalStrengthItem.image = UIImage(named: "BLESignal\(status)")
    }
    
    func didReceiveMessage(message: String) {
        SwiftMessagesWrapper.showGenericMessage(title: "Message", body: message)
    }
    
    func didReceiveCommand(command: IncomingCommand) {
        guard let cmdToIndex = CommandToIndex.currentTable[command] else { return }
        if let cells = tableView.cellForRow(at: IndexPath(row: 0, section: cmdToIndex.indexInTableView)) as? DashboardSlidableTableViewCell {
            cells.performOperations(onCellWith: cmdToIndex.collecIndexPath, command: command)
            
            //perform updates on the data structure to make sure they are re-dequeued correctly
            controller.updateData(cmdToIndex: cmdToIndex, cell: cells)
            
        }
    }
    
    // MARK: - IBActions
    @IBAction func disconnectBLE(_ sender: UIBarButtonItem) {
        BLEManager.current.disconnect()
        dismiss(animated: true, completion: nil)
        BLEManager.current.delegate = nil
        signalStrengthTimer?.invalidate()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ppc = segue.destination.popoverPresentationController {
            ppc.delegate = self
            BLEManager.current.delegate = nil
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardSlidableTableViewCell.identifier,
                                                 for: indexPath)
        if let cell = cell as? DashboardSlidableTableViewCell {
            // row is always 0, but section indexes corresponds to the data structure
            cell.controllableObject = controller.bleControls[indexPath.section]
            cell.sectionIndex = indexPath.section
            if let lightControl = controller.lightControl(in: indexPath.section) {
                cell.action = { [weak self] in
                    guard let strongSelf = self else { return }
                    let lightVC = LightControlTableViewController(data: lightControl)
                    lightVC.title = strongSelf.controller.bleControls[indexPath.section].sectionHeader
                    strongSelf.navigationController?.pushViewController(lightVC, animated: true)
                }
            } else if let longProcesses = controller.bleControls[indexPath.section].controls[indexPath.row].longProcessCommands {
                cell.action = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.prepareForLottieAnimation(dimAndDisable: true)
                    let animSize = strongSelf.tableView.bounds.width * 0.6
                    let animationView = LottieActivityIndicator(frame: CGRect(x: 0, y: 0,
                                                                              width: animSize, height: animSize))
                    animationView.configure(startCommand: longProcesses.0, endCommand: longProcesses.1) {
                        strongSelf.prepareForLottieAnimation(dimAndDisable: false)
                    }
                    strongSelf.view.addSubview(animationView)
                }
            }
        }
        return cell
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

extension DashboardViewController: UIPopoverPresentationControllerDelegate {
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        // unlink the delegate from the popover
        BLEManager.current.delegate = nil
        // set the delegate to self
        BLEManager.current.delegate = self
    }
}

extension DashboardViewController {
    fileprivate func prepareForLottieAnimation(dimAndDisable: Bool) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tableView.alpha = dimAndDisable ? 0.3 : 1.0
            self?.tableView.isUserInteractionEnabled = !dimAndDisable
        })
    }
}
