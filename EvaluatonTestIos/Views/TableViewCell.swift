//
//  TableViewCell.swift
//  EvaluatonTestIos
//
//  Created by Константин Сабицкий on 08.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var numberOfSong: UILabel!
    
    static let reuseId = "TableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
