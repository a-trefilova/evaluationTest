//
//  CollectionViewTests.swift
//  EvaluatonTestIosTests
//
//  Created by Константин Сабицкий on 09.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import XCTest
import UIKit
@testable import EvaluatonTestIos

class CollectionViewTests: XCTestCase {

    var sut: ViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ViewController.self))
        sut = vc as? ViewController
        sut.loadViewIfNeeded()
    }
    
    func testWhenViewIsLoadedCollectionViewNotNill() {
        XCTAssertNotNil(sut.collectionView)
        
    }
    
    func testWhenViewIsLoadedNetworkManagerIsNotNil() {
        XCTAssertNotNil(sut.nm)
    }
    
    
    func testWhenViewIsLoadedCollectionViewDatasourceEqualsCollectionViewDelegate() {
        XCTAssertEqual(sut.collectionView.dataSource as? ViewController, sut.collectionView.delegate as? ViewController)
    }
    
    func testSelectedCellPushesDetailVC() {
        let mockNavController = MockNavController()
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = mockNavController
        sut.loadViewIfNeeded()
        let searchItem = SearchItem(wrapperType: .collection, kind: .song, artistId: nil, artistName: nil, collectionId: nil, collectionName: "Foo", collectionViewUrl: nil, trackId: nil, trackName: nil, trackViewUrl: nil, artworkUrl30: nil, artworkUrl60: nil, artworkUrl100: nil, releaseDate: "Bar")
        sut.searchResults = [searchItem]
        guard let detailVC = mockNavController.pushedVC as? DetailViewController else {
            //XCTFail()
            return
        }
        detailVC.loadViewIfNeeded()
        XCTAssertNotNil(detailVC.searchItems)
        XCTAssertTrue(detailVC.searchItems?.first?.collectionName == searchItem.collectionName)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}

extension CollectionViewTests {
    class MockNavController: UINavigationController {
        var pushedVC: UIViewController?
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedVC = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
