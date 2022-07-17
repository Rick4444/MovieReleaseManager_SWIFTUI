//
//  MoviewDetailViewModal.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class Observer : ObservableObject {
    
    @Published var movieListData = [MovieListData]()
    @Published var topRatedMovieListData = [TopRatedMovieListData]()
    @Published var movieTralerLink = [MovieTrailerLink]()
    
    
    init() {
        getPopularMovieList()
        getTopRatedMovieList()
    }
    
    func getPopularMovieList(pageno: Int = 1)
    {
        let apikey = "https://api.themoviedb.org/3/movie/popular?api_key=60fbac66941dde66292749d11f73a900&language=en-US&page=\(pageno)"
        
        AF.request(apikey, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseData { response in
                
                switch response.result {
                    
                case .success( _):
                    guard let data = response.data else { return }
                    let isResponseCode = response.response?.statusCode
                    if(isResponseCode == 200){
                        print(JSON(data))
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
        let apikey = "https://api.themoviedb.org/3/movie/top_rated?api_key=60fbac66941dde66292749d11f73a900&language=en-US&page=\(pageno)"
        AF.request(apikey, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseData { response in
                
                switch response.result {
                case .success( _):
                    guard let data = response.data else { return }
                    let isResponseCode = response.response?.statusCode
                    if(isResponseCode == 200){
                        print(JSON(data))
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
        let apikey = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=60fbac66941dde66292749d11f73a900&language=en-US"
        AF.request(apikey, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseData { response in
                
                switch response.result {
                case .success( _):
                    guard let data = response.data else { return }
                    let isResponseCode = response.response?.statusCode
                    if(isResponseCode == 200){
                        print(JSON(data))
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


