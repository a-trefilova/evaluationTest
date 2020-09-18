//
//  EvaluatonTestIosTests.swift
//  EvaluatonTestIosTests
//
//  Created by Константин Сабицкий on 09.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import XCTest
import UIKit
@testable import EvaluatonTestIos

class EvaluatonTestIosTests: XCTestCase {

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialVCisViewControllerVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootVC = navController.viewControllers.first as! AlbumsViewController
        
        XCTAssertTrue(rootVC is AlbumsViewController)
    }

    
}

class CollectionViewCellTests: XCTestCase {
    
    var cell: SearchCell!
    var controller: AlbumsViewController!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: String(describing: AlbumsViewController.self)) as? AlbumsViewController
        controller.loadViewIfNeeded()
        let collectionView = controller.collectionView
        let datasource = FakeDataSource()
        collectionView?.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: SearchCell.reuseId)
        cell = collectionView?.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseId, for: IndexPath(item: 0, section: 0)) as! SearchCell
            
    }
    
    func testCellHasLabel() {
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testCellHasImageView() {
        XCTAssertNotNil(cell.albumImageView)
    }
    
    func testConfigureCell() {
        let searchItem = SearchItem(wrapperType: .collection, kind: .song, artistId: nil, artistName: nil, collectionId: nil, collectionName: "Foo", collectionViewUrl: nil, trackId: nil, trackName: nil, trackViewUrl: nil, artworkUrl30: nil, artworkUrl60: nil, artworkUrl100: nil, releaseDate: nil)
        cell.cellItem = searchItem
        XCTAssertEqual(cell.cellItem?.collectionName, searchItem.collectionName)
    }
    

}

extension CollectionViewCellTests {
    class FakeDataSource: NSObject, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
        
        
        
    }
}
