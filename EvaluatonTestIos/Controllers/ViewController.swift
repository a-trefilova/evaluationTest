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
    
    var results = [SearchItem]()
    var nm = NetworkManager()
    var page: Int = 1
    
    //private var searchCon
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: SearchCell.reuseId)
        getData()
        
        
    }


    private func getData() {
        nm.getData(by: "black", entity: nil, page: page, limit: 20) { (results) in

            for item in results {
                if !self.results.contains(where: {$0.collectionName == item.collectionName}) {
                    self.results.append(item)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
            
        }
    }
    
    private func calculateSizeOfCells() -> CGSize {
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width
        let height = screenSize.height
        let widthOfCell = width/2
        let heightOfCell = height/2
        
        return CGSize(width: widthOfCell, height: heightOfCell)
    }
    
    private func loadingMoreData() {
        page =  page + 1
        nm.getData(by: "black", entity: nil, page: page, limit: 20) { (items) in
            for item in items {
                if !self.results.contains(where: {$0.collectionName == item.collectionName}) {
                    self.results.append(item)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
        results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseId, for: indexPath) as! SearchCell
        let item = results[indexPath.item]
        //cell.titleLabel.text = item.artistName
        cell.cellItem = item
        cell.configureCell()
        if indexPath.item == results.count - 1 {
            loadingMoreData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //calculateSizeOfCells()
//        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
//        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
//        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
//        return CGSize(width: size, height: size)
        let padding: CGFloat = 30
        let collectonViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectonViewSize/2, height: collectonViewSize/2)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = results[indexPath.item]
        let detailVC = DetailViewController()
        nm.getData(by: item.collectionName ?? "black", entity: "musicTrack", page: 0, limit: 50) { (results) in
            var resultsArray = [SearchItem]()
            for result in results {
                if result.collectionId == item.collectionId {
                    resultsArray.append(result)
                }
            }
            print(resultsArray)
            DispatchQueue.main.async {
                detailVC.searchItems = resultsArray
                detailVC.loadViewIfNeeded()
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
        }
        
    }
}

extension ViewController: UISearchBarDelegate {
    
}
