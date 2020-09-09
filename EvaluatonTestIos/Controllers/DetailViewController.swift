//
//  DetailViewController.swift
//  EvaluatonTestIos
//
//  Created by Константин Сабицкий on 07.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import Nuke
class DetailViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    
    var searchItems: [SearchItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.reuseId)
        setUpHeaderView()
        
    }

    
    
    private func setUpHeaderView() {
        if let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as? HeaderView {
            headerView.albumName.text = searchItems?.first?.collectionName
            headerView.artistName.text = searchItems?.first?.artistName
            let string = searchItems?.first?.releaseDate
            let year = string?.dropLast(16)
            headerView.yearLabel.text = String(year!)
            guard let url = URL(string: (searchItems?.first?.artworkUrl100)!) else { return }
            Nuke.loadImage(with: url, into: headerView.albumImaeView)
            self.tableView.tableHeaderView = headerView
        }
       
        
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId, for: indexPath) as! TableViewCell
        guard let item = searchItems?[indexPath.row] else { return cell }
        cell.textLabel?.text = item.trackName
        cell.numberOfSong.text = String(indexPath.row + 1) + "."
        return cell
    }
    
    
}
