//
//  DetailViewController.swift
//  EvaluatonTestIos
//
//  Created by Константин Сабицкий on 07.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import Nuke
class SongsListViewController: UIViewController {

   
    @IBOutlet weak var songsListTableView: UITableView!
    
    var searchItems: [SearchItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songsListTableView.dataSource = self
        songsListTableView.delegate = self
        songsListTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.reuseId)
        setUpHeaderView()
        
    }

    
    
    private func setUpHeaderView() {
        if let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as? HeaderView {
            headerView.albumName.text = searchItems?.first?.collectionName
            headerView.artistName.text = searchItems?.first?.artistName
            let string = searchItems?.first?.releaseDate
            guard let year = string?.dropLast(16) else { return }
            headerView.yearLabel.text = String(year)
            guard let url = URL(string: (searchItems?.first?.artworkUrl100)!) else { return }
            Nuke.loadImage(with: url, into: headerView.albumImaeView)
            headerView.albumImaeView.layer.cornerRadius = 20
            self.songsListTableView.tableHeaderView = headerView
            headerView.center = self.songsListTableView.tableHeaderView!.center
        }
       
        
    }
}

extension SongsListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
