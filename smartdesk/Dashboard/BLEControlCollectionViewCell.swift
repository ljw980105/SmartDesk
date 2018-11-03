//
//  BLEControlCollectionViewCell.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class BLEControlCollectionViewCell: UICollectionViewCell {
    static let identifier = "slidableCollectionCell"
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var backdrop: UIView!
    
    private let offColor = UIColor(red: 252/255, green: 184/255, blue: 0/255, alpha: 1.0)
    private let onColor = UIColor(red: 23/255, green: 162/255, blue: 18/255, alpha: 1.0)
    
    var controllableObject: BLEControlEntity? {
        didSet {
            statusLabel.text = controllableObject?.name
            if controllableObject?.name == "On" {
                backdrop.backgroundColor = onColor
                statusLabel.textColor = UIColor.white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backdrop.layer.cornerRadius = 15.0
        backdrop.clipsToBounds = true
    }
    
    func adjustUI(with command: IncomingCommand) {
        switch command {
        case .deskLightOn:
            statusLabel.text = "On"
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut],
                           animations: { [weak self] in
                self?.backdrop.backgroundColor = self?.onColor
                }, completion: nil)
        case .deskLightOff:
            statusLabel.text = "Off"
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut],
                           animations: { [weak self] in
                self?.backdrop.backgroundColor = self?.offColor
                }, completion: nil)
        }
    }
}
