//
//  BLEControlEntity.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/12/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

protocol BLEControllable {
    var sectionHeader: String { get set }
    var controls: [BLEControlEntity] { get set }
    var containsSlider: Bool { get set }
}
