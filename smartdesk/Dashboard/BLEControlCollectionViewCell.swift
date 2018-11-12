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
    private let defaultColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
   
    private lazy var lookUpTable: [String: UIColor] = {
        var table: [String: UIColor] = [:]
        table["On"] = onColor
        table["Off"] = offColor
        table["Erase"] = offColor
        table["No-erase"] = onColor
        table["Locked"] = UIColor.red
        table["Unlocked"] = onColor
        table["Front"] = UIColor.purple
        table["Side"] = UIColor.brown
        return table
    }()
    
    var controllableObject: BLEControlEntity? {
        didSet {
            statusLabel.text = controllableObject?.name
            if let controlType = controllableObject?.controlType {
                if case .toggle = controlType {
                    statusLabel.textColor = UIColor.white
                    backdrop.backgroundColor = lookUpTable[controllableObject?.name ?? ""]
                } else if case .biometric = controlType {
                    statusLabel.textColor = UIColor.white
                    backdrop.backgroundColor = lookUpTable[controllableObject?.name ?? ""]
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backdrop.layer.cornerRadius = 15.0
        backdrop.clipsToBounds = true
    }
    
    func adjustUI(with command: IncomingCommand) {
        var colorStr = ""
        switch command {
        case .deskLightOn, .whiteboardLightOn, .whiteboardEraseOn,
             .outletsFacingFront, .lockableCmptLocked:
            colorStr = controllableObject?.switchLabels?.0 ?? ""
        case .deskLightOff, .whiteboardLightOff, .whiteboardEraseOff,
             .outletsFacingSide, .lockableCmptUnlocked:
            colorStr = controllableObject?.switchLabels?.1 ?? ""
            statusLabel.text = colorStr
        }
        statusLabel.text = colorStr
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut],
                       animations: { [weak self] in
            self?.backdrop.backgroundColor = self?.lookUpTable[colorStr]
        }, completion: nil)
    }
}
