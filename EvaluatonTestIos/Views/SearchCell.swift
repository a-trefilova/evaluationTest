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
    
    var cellItem: SearchItem!
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    static let reuseId = "CollectionCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    func configureCell() {
        titleLabel.text = cellItem.collectionName
        guard let urlString = cellItem.artworkUrl100 else { return }
        guard let url = URL(string: urlString) else { return }
        Nuke.loadImage(with: url, into: albumImageView)
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 20
    }
}
