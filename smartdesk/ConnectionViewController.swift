//
//  ConnectionViewController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController, BLEManagerDelegate {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectButton.isHidden = true
        connectButton.layer.cornerRadius = 10.0
        connectButton.clipsToBounds = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            var newFrame = self?.logo.frame
            let newOrigin = (newFrame?.origin.y ?? 0) - 100
            newFrame?.origin.y = newOrigin
            if let frame = newFrame {
                self?.logo.frame = frame
            }
        }, completion: { [weak self] _ in
            self?.connectButton.isHidden = false
            //strongSelf.disableUI()
            BLEManager.current.delegate = self
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if BLEManager.current.delegate == nil {
            BLEManager.current.delegate = self
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func connect(_ sender: UIButton) {
        disableUI()
        BLEManager.current.connect()
    }
    
    // MARK: - BLEManagerDelegate
    
    func didReceiveError(error: BLEError?) {
        error?.handleError()
        enableUI()
    }
    
    func readyToSendData() {
        enableUI()
        BLEManager.current.delegate = nil
        performSegue(withIdentifier: "successfulConnection", sender: self)
    }
    
    // MARK: - Private methods
    
    private func disableUI() {
        connectButton.isEnabled = false
        connectButton.alpha = 0.5
        connectButton.setTitle("Connecting", for: .normal)
    }
    
    private func enableUI() {
        connectButton.isHidden = false
        connectButton.isEnabled = true
        connectButton.alpha = 1
        connectButton.setTitle("Connect", for: .normal)
    }
    
    
}
