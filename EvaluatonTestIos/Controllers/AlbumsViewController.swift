//
//  ViewController.swift
//  EvaluatonTestIos
//
//  Created by Константин Сабицкий on 05.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var mostRelevantRequestsTableView: UITableView!
    @IBOutlet weak var albumsCollectionView: UICollectionView!

    var searchResults: [SearchItem]? {
        didSet {
            searchResults = searchResults?.sorted {
                var isSorted = false
                if let first = $0.collectionName, let second = $1.collectionName {
                    isSorted = first < second
                }
                return isSorted
            }
            DispatchQueue.main.async {
                self.albumsCollectionView.reloadData()
            }
            
        }
    }
    var nm = NetworkManager()
    var resultsPage: Int = 0
    var mostRelevantResultsStrings: [String]? {
        didSet {
            print("RESULTS ARE HERE")
        }
    }
    
    private let bcImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background")
        imageView.image = image
        return imageView
    }()
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mostRelevantRequestsTableView.dataSource = self
        self.mostRelevantRequestsTableView.delegate = self
        self.mostRelevantRequestsTableView.tableFooterView = UIView()
        self.albumsCollectionView.dataSource = self
        self.albumsCollectionView.delegate = self
        albumsCollectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: SearchCell.reuseId)
        
        setUpSearchBar()
        setUpSearchCollectionBackgroundView()
        setUpCollectionView()
        setUpMostRelevantTableViewConstraints()
        //setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            bcImageView.isHidden = false

        
    }
    
    private func setUpMostRelevantTableViewConstraints() {
        mostRelevantRequestsTableView.leadingAnchor.constraint(equalTo: albumsCollectionView.leadingAnchor).isActive = true
        mostRelevantRequestsTableView.trailingAnchor.constraint(equalTo: albumsCollectionView.trailingAnchor).isActive = true
        mostRelevantRequestsTableView.topAnchor.constraint(equalTo: albumsCollectionView.topAnchor).isActive = true
        mostRelevantRequestsTableView.bottomAnchor.constraint(equalTo: albumsCollectionView.bottomAnchor).isActive = true
    }
    
    private func setUpSearchCollectionBackgroundView() {
        
        bcImageView.contentMode = .bottom
        bcImageView.frame.size.height = albumsCollectionView.frame.size.height / 2
        bcImageView.frame.size.width = albumsCollectionView.frame.size.width / 2
        //bcImageView.center = self.view.center
        bcImageView.alpha = 0.5
        albumsCollectionView.backgroundView = bcImageView
        
    }
    
    private func setUpCollectionView() {
        let bcColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                
            case .unspecified, .light:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            @unknown default:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
        albumsCollectionView.backgroundColor = bcColor
    }

    private func setUpSearchBar() {
        navigationItem.title = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search album or song"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationController?.navigationBar.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
    }

    
///Method for loading more data from api, by the way, variables "page"  and "limit" are responsible for parameter "offset" (for more details see NetworkManager.swift)
    private func loadingMoreData(by term: String) {
        resultsPage =  resultsPage + 1
        nm.getData(by: term, entity: nil, page: resultsPage, limit: 20) { (items) in
            guard let results = self.searchResults else { return }
            for item in items {
                if !results.contains(where: {$0.collectionName == item.collectionName}) {
                    self.searchResults?.append(item)
                }

            }

        }
    }
    
    
}

extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension AlbumsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let searchResults = searchResults else { return 1}
        return searchResults.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseId, for: indexPath) as! SearchCell
            guard let searchResults = searchResults else  { return cell }
            let item = searchResults[indexPath.item]
            cell.cellItem = item
            cell.configureCell()
            if indexPath.item == searchResults.count - 1 {
                guard let text = searchController.searchBar.text else { return cell }
                loadingMoreData(by: text)
            }
            return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 0
        let collectonViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectonViewSize/2, height: collectonViewSize/2)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.isUserInteractionEnabled = false
        guard let searchResults = searchResults else  { return }
        let item = searchResults[indexPath.item]
        let detailVC = SongsListViewController()
        guard let collectionName = item.collectionName else { return }
        nm.getData(by: collectionName, entity: "musicTrack", page: 0, limit: 50) { (results) in
            var resultsArray = [SearchItem]()
            for result in results {
                if result.collectionId == item.collectionId {
                    resultsArray.append(result)
                }
            }
            DispatchQueue.main.async {
                detailVC.searchItems = resultsArray
                detailVC.loadViewIfNeeded()
                self.navigationController?.pushViewController(detailVC, animated: true)
                self.view.isUserInteractionEnabled = true
            }
            
        }
        
    }
}



extension AlbumsViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text!.count > 0 else { return }
        prepareDataForDatasource(by: searchController.searchBar.text!)
    }
    
    private func getDataFromApi(by word: String) {
        nm.getData(by: word, entity: nil, page: 0, limit: 50) { (results) in
            var resultsArray = [SearchItem]()
            for result in results {
                if !resultsArray.contains(where: {$0.collectionId == result.collectionId}) {
                    resultsArray.append(result)
                }
            }
            self.searchResults = resultsArray
        }
    }
    
    private func prepareDataForDatasource(by string: String) {
           guard string.count > 3 else { return }
           nm.getData(by: string, entity: "album", page: 0, limit: 20) { (results) in
               var data = [String]()
            
               for item in results {
                    guard let name = item.collectionName else { return }
                    if name.contains(string) {
                        data.append(name)
                    }
               }
            
                if data.count > 4 {
                    let first = data[0]
                    let second = data[1]
                    let third = data[2]
                    let fourth = data[3]
                    data = [first, second, third, fourth]
                }
                self.mostRelevantResultsStrings = data
                DispatchQueue.main.async {
                    self.mostRelevantRequestsTableView.reloadData()
                }
            
           }
           
       }
}

extension AlbumsViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        mostRelevantRequestsTableView.isHidden = false
        albumsCollectionView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mostRelevantRequestsTableView.reloadData()
        bcImageView.isHidden = true
        guard let text = searchBar.text else {
            bcImageView.isHidden = false
            return
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mostRelevantRequestsTableView.isHidden = true
        getDataFromApi(by: searchBar.text!)
        albumsCollectionView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mostRelevantRequestsTableView.isHidden = true
        
        albumsCollectionView.isHidden = false
        albumsCollectionView.backgroundView = bcImageView
        albumsCollectionView.reloadData()
    }
    
}

extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let strings = mostRelevantResultsStrings else { return 0 }
        return  strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableCell")
        guard let strings = mostRelevantResultsStrings else { return cell }
        cell.textLabel?.text = strings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let strings = mostRelevantResultsStrings else { return }
        let string = strings[indexPath.row]
        searchController.searchBar.text = string
        searchController.searchBar.endEditing(true)
        self.searchBarSearchButtonClicked(searchController.searchBar)
        
    }
    
   
    
}
