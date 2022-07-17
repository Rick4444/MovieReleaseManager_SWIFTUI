//
//  MovieReleaseModal.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import Foundation

// MARK: - MovieList
struct MovieList: Codable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let posterPath, releaseDate, title, overview: String?
    let video: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video, overview
    }
}

struct MovieListData : Identifiable{
    public var id: Int?
    public var posterPath, releaseDate, overview, title: String?
}


struct TopRatedMovieListData : Identifiable{
    public var id: Int?
    public var posterPath, releaseDate, overview, title: String?
}



// MARK: - MovieData
struct MovieData: Codable {
    let id: Int?
    let results: [MovieDataResult]?
}

// MARK: - MovieDataResult
struct MovieDataResult: Codable {
    let iso639_1, iso3166_1, name, key: String?
    let publishedAt, site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key
        case publishedAt = "published_at"
        case site, size, type, official, id
    }
}


struct MovieTrailerLink : Identifiable{
    public var id: Int?
    public var Key: String?
    
}

