//
//  ViewController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLEManagerDelegate {
    @IBOutlet weak var sendDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BLEManager.current.delegate = self
        sendDataButton.isHidden = true
    }
    
    func readyToSendData() {
        sendDataButton.isHidden = false
    }

    @IBAction func sendData(_ sender: UIButton) {
        BLEManager.current.send(data: "A")
    }
    
}

