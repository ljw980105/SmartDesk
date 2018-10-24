//
//  LightControlColorCollectionViewCell.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/24/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class LightControlColorCollectionViewCell: UICollectionViewCell {
    static let identifier = "LightColorCollecCell"
    
    @IBOutlet weak var colorView: UIView!
    
    var color: UIColor = UIColor.white {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = 25.0
        colorView.clipsToBounds = true
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = 0.5
    }

}
