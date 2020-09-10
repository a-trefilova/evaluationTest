//
//  CollectionViewCell.swift
//  EvaluatonTestIos
//
//  Created by Константин Сабицкий on 06.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import Nuke

class SearchCell: UICollectionViewCell {
    
    var cellItem: SearchItem?
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    static let reuseId = "CollectionCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTitleLabel()
        // Initialization code
    }
     
    func configureCell() {
        guard let cellItem = cellItem else { return }
        titleLabel.text = cellItem.collectionName
        guard let urlString = cellItem.artworkUrl100 else { return }
        guard let url = URL(string: urlString) else { return }
        Nuke.loadImage(with: url, into: albumImageView)
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 20
        
    }
    
    private func setUpTitleLabel() {
        let bcColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                
            case .unspecified, .light:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case .dark:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            @unknown default:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        titleLabel.textColor = bcColor
        
    }
}
