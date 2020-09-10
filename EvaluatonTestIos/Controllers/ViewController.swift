//
//  ViewController.swift
//  EvaluatonTestIos
//
//  Created by Константин Сабицкий on 05.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

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
                self.collectionView.reloadData()
            }
            
        }
    }
    var nm = NetworkManager()
    var page: Int = 0
    
    
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
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: SearchCell.reuseId)
        setUpSearchBar()
        setUpBackgroundView()
        setUpCollectionView()
        //setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            bcImageView.isHidden = false

        
    }
    
    private func setUpBackgroundView() {
        
        bcImageView.contentMode = .bottom
        bcImageView.frame.size.height = collectionView.frame.size.height / 2
        bcImageView.frame.size.width = collectionView.frame.size.width / 2
        //bcImageView.center = self.view.center
        bcImageView.alpha = 0.5
        collectionView.backgroundView = bcImageView
        
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
        collectionView.backgroundColor = bcColor
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
        page =  page + 1
        nm.getData(by: term, entity: nil, page: page, limit: 20) { (items) in
            guard let results = self.searchResults else { return }
            for item in items {
                if !results.contains(where: {$0.collectionName == item.collectionName}) {
                    self.searchResults?.append(item)
                }

            }

        }
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
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
        let padding: CGFloat = 30
        let collectonViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectonViewSize/2, height: collectonViewSize/2)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchResults = searchResults else  { return }
        let item = searchResults[indexPath.item]
        let detailVC = DetailViewController()
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
            }
            
        }
        
    }
}



extension ViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 0 {
        getDataFromApi(by: searchController.searchBar.text!)
        }
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
}

extension ViewController: UISearchBarDelegate {

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        bcImageView.isHidden = true
        guard let text = searchBar.text else {
            bcImageView.isHidden = false
            return
        }
    }

}
