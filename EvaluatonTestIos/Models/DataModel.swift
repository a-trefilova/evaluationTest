//
//  DataModel.swift
//  EvaluationTest
//
//  Created by Константин Сабицкий on 04.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation

struct Results: Codable {
    let resultCount: Int
    let results: [SearchItem]?
}

struct SearchItem: Codable {
    
    let wrapperType: WrapperType?
    let kind: Kind?
    let artistId: Int?
    let artistName: String?
    let collectionId: Int?
    let collectionName: String?
    let collectionViewUrl: String?
    let trackId: Int?
    let trackName: String?
    let trackViewUrl: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let releaseDate: String?
}

enum Kind: String, Codable {
    case featureMovie = "feature-movie"
    case musicVideo = "music-video"
    case song = "song"
}

enum WrapperType: String, Codable {
    case track = "track"
    case collection = "collection"
}
