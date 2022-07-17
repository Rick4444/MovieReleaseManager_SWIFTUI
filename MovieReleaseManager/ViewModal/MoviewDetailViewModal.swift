//
//  MoviewDetailViewModal.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import Foundation
import Alamofire
import SwiftyJSON

enum HTTPStatusCode: Int {
    case success = 200
    case error = 500
}



final class Observer : ObservableObject {
    
    @Published var movieListData = [MovieListData]()
    @Published var topRatedMovieListData = [TopRatedMovieListData]()
    @Published var movieTralerLink = [MovieTrailerLink]()
    
    @Published var showAlert = false
    
    
    
    init() {
        getPopularMovieList()
        getTopRatedMovieList()
    }
    
    func reloadPopular() async {
        getPopularMovieList()
    }
    
    func reloadTopRated() async {
        getTopRatedMovieList()
    }
    
    
    func getPopularMovieList(pageno: Int = 1)
    {
        let requestURL = "\(Constants.baseURL)\(Constants.requestedDataPopularType)?api_key=\(Constants.APIKEY)&language=\(Constants.dataLanguage)&page=\(pageno)"
        
        AF.request(requestURL, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseData { response in
                
                switch response.result {
                    
                case .success( _):
                    guard let data = response.data else { return }
                    let isResponseCode = response.response?.statusCode
                    if(isResponseCode == HTTPStatusCode.success.rawValue){
                        let  res = try! JSONDecoder().decode(MovieList.self, from: data)
                        for val in res.results ?? [] {
                            self.movieListData.append(MovieListData(id: val.id, posterPath: val.posterPath, releaseDate: val.releaseDate, overview: val.overview, title: val.title))
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
    }
    
    func getTopRatedMovieList(pageno: Int = 1)
    {
        let requestURL = "\(Constants.baseURL)\(Constants.requestedDataTopRatedType)?api_key=\(Constants.APIKEY)&language=\(Constants.dataLanguage)&page=\(pageno)"
        AF.request(requestURL, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseData { response in
                
                switch response.result {
                case .success( _):
                    guard let data = response.data else { return }
                    let isResponseCode = response.response?.statusCode
                    if(isResponseCode == HTTPStatusCode.success.rawValue){
                        let  res = try! JSONDecoder().decode(MovieList.self, from: data)
                        
                        for val in res.results ?? [] {
                            self.topRatedMovieListData.append(TopRatedMovieListData(id: val.id, posterPath: val.posterPath, releaseDate: val.releaseDate, overview: val.overview, title: val.title))
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getMovieData(id: Int = 1)
    {
        let requestURL = "\(Constants.baseURL)\(id)/videos?api_key=\(Constants.APIKEY)&language=\(Constants.dataLanguage))"
        
        AF.request(requestURL, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseData { response in
                
                switch response.result {
                case .success( _):
                    guard let data = response.data else { return }
                    let isResponseCode = response.response?.statusCode
                    if(isResponseCode == HTTPStatusCode.success.rawValue){
                        let  res = try! JSONDecoder().decode(MovieData.self, from: data)
                        for val in res.results ?? [] {
                            self.movieTralerLink.append(MovieTrailerLink(id: res.id, Key: val.key))
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
}


