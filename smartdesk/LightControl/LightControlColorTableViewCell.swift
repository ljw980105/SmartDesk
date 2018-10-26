//
//  LightControlColorTableViewCell.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/23/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit

class LightControlColorTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "lightControlColor"

    var colorCommand: String = ""
    var colors: [UIColor] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(UINib(nibName: "LightControlColorCollectionViewCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: LightControlColorCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
}

extension LightControlColorTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LightControlColorCollectionViewCell.identifier,
                                                      for: indexPath)
        if let cell = cell as? LightControlColorCollectionViewCell {
            cell.color = colors[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Haptic.current.beep()
        BLEManager.current.send(colorCommand: colorCommand, color: colors[indexPath.row])
    }
    
}
