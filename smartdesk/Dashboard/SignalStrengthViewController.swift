//
//  SignalStrengthViewController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/18/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class SignalStrengthViewController: UIViewController, BLEManagerDelegate {
    @IBOutlet weak var statusString: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BLEManager.current.delegate = self
    }
    
    func didReceiveRSSIReading(reading: Int, status: String) {
        statusString.text = "\(status) (\(reading)dBm)"
    }

}
