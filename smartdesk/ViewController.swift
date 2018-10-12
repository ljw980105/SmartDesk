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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BLEManager.current.delegate = self
    }
    
    func didReceiveError(error: BLEError?) {
        error?.showErrorMessage()
        BLEManager.current.delegate = nil
        dismiss(animated: true, completion: nil)
    }
    
    func readyToSendData() {
        //sendDataButton.isHidden = false
    }

    @IBAction func sendData(_ sender: UIButton) {
        BLEManager.current.send(string: "A")
    }
    
}

