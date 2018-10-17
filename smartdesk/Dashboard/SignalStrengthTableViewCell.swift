//
//  SignalStrengthTableViewCell.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/15/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class SignalStrengthTableViewCell: UITableViewCell {
    static let identifier = "signalStrength"
    @IBOutlet weak var strengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
