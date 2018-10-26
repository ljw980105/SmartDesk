//
//  ColorPickerViewController.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/26/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, HSBColorPickerDelegate {
    
    @IBOutlet weak var colorPicker: HSBColorPicker!
    var didSelectColor: ((UIColor) -> Void)? = nil
    
    init() {
        super.init(nibName: "ColorPickerViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    // MARK: - HSBColorPickerDelegate
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor,
                                    point: CGPoint, state: UIGestureRecognizer.State) {
        didSelectColor?(color)
        colorPicker.delegate = nil
        popoverPresentationController?.delegate = nil
        dismiss(animated: true, completion: nil)
    }

}
