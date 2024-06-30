//
//  ITunesSearchResult.swift
//  iTunesTest
//
//  Created by Виктор on 03.03.2024.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let iTunes = try? JSONDecoder().decode(ITunes.self, from: jsonData)

import Foundation

// MARK: - ITunesSearchResult
struct ITunesSearchResult: Codable {
    let resultCount: Int
    let results: [ResultType]
    
    init() {
        self.resultCount = 0
        self.results = []
    }
}

// MARK: - Result
struct ResultType: Codable {
    let wrapperType: String
    let kind: String?
    let artistID, collectionID, trackID: Int?
    let artistName: String
    let collectionName, trackName, collectionCensoredName, trackCensoredName: String?
    let artistViewURL, collectionViewURL, trackViewURL: String?
    let previewURL: String?
    let artworkUrl30: String?
    let artworkUrl60, artworkUrl100: String?
    let collectionPrice: Double
    let trackPrice: Double?
//    let releaseDate: Date
//    let collectionExplicitness: Explicitness
//    let trackExplicitness: Explicitness?
//    let discCount, discNumber, trackCount, trackNumber: Int?
//    let trackTimeMillis: Int?
//    let country: Country
//    let currency: Currency
//    let primaryGenreName: String
//    let isStreamable: Bool?
//    let copyright, description, contentAdvisoryRating: String?
//    let collectionArtistID: Int?
//    let collectionArtistViewURL: String?
//    let trackRentalPrice, collectionHDPrice, trackHDPrice, trackHDRentalPrice: Double?
//    let shortDescription, longDescription: String?
//    let hasITunesExtras: Bool?
//    let collectionArtistName: String?
//    let feedURL: String?
//    let artworkUrl600: String?
//    let genreIDS, genres: [String]?
//    let amgArtistID: Int?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100
        case collectionPrice, trackPrice
//        case releaseDate
//        case collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable, copyright, description, contentAdvisoryRating
//        case collectionArtistID = "collectionArtistId"
//        case collectionArtistViewURL = "collectionArtistViewUrl"
//        case trackRentalPrice
//        case collectionHDPrice = "collectionHdPrice"
//        case trackHDPrice = "trackHdPrice"
//        case trackHDRentalPrice = "trackHdRentalPrice"
//        case shortDescription, longDescription, hasITunesExtras, collectionArtistName
//        case feedURL = "feedUrl"
//        case artworkUrl600
//        case genreIDS = "genreIds"
//        case genres
//        case amgArtistID = "amgArtistId"
    }
}
