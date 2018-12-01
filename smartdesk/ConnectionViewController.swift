//
//  ConnectionViewController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import Lottie

class ConnectionViewController: UIViewController, BLEManagerDelegate, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectButton.isHidden = true
        connectButton.layer.cornerRadius = 10.0
        connectButton.clipsToBounds = true
        optionsButton.isHidden = true
        versionLabel.isHidden = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            var newFrame = self?.logo.frame
            let newOrigin = (newFrame?.origin.y ?? 0) - 100
            newFrame?.origin.y = newOrigin
            if let frame = newFrame {
                self?.logo.frame = frame
            }
        }, completion: { [weak self] _ in
            self?.connectButton.isHidden = false
            self?.optionsButton.isHidden = false
            self?.versionLabel.isHidden = false
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            self?.versionLabel.text = "v\(version)"
            //strongSelf.disableUI()
            BLEManager.current.delegate = self
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func connect(_ sender: UIButton) {
        disableUI()
        if BLEManager.current.delegate == nil {
            BLEManager.current.delegate = self
        }
        UserDefaults.setTransitionAnimationNeeded()
        BLEManager.current.connect()
    }
    
    @IBAction func showOptions(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Force Connect", style: .default,
                                            handler: { [weak self] _ in
            if BLEManager.current.delegate == nil {
                BLEManager.current.delegate = self
            }
            self?.disableUI()
            UserDefaults.setTransitionAnimationNeeded()
            BLEManager.current.forceConnect()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = optionsButton
        actionSheet.popoverPresentationController?.sourceRect = optionsButton.bounds
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    // MARK: - BLEManagerDelegate
    
    func didReceiveError(error: BLEError?) {
        error?.showErrorMessage()
        enableUI()
    }
    
    func readyToSendData() {
        // send a command to wake up the BLE module
        BLEManager.current.send(string: OutgoingCommands.whiteboardLightToggle)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            BLEManager.current.send(string: OutgoingCommands.deskLightToggle)
        }
        enableUI()
        BLEManager.current.delegate = nil
        performSegue(withIdentifier: "successfulConnection", sender: self)
    }
    
    // MARK: - Private methods
    
    private func disableUI() {
        connectButton.isEnabled = false
        connectButton.alpha = 0.5
        connectButton.setTitle("Connecting", for: .normal)
        optionsButton.isEnabled = false
        optionsButton.alpha = 0.5
    }
    
    private func enableUI() {
        connectButton.isHidden = false
        connectButton.isEnabled = true
        connectButton.alpha = 1
        connectButton.setTitle("Connect", for: .normal)
        optionsButton.isEnabled = true
        optionsButton.alpha = 1
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        destinationVC.modalPresentationStyle = .custom
        destinationVC.transitioningDelegate = self
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LOTAnimationTransitionController(animationNamed: "TransitionAnimation2",
                                                fromLayerNamed: nil,
                                                toLayerNamed: "outLayer",
                                                applyAnimationTransform: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
