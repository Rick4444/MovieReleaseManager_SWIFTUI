//
//  PopularView.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI
import CoreData
import SDWebImageSwiftUI
import Network

@available(iOS 15.0, *)
struct PopularView : View {
    
    var body: some View {
        popularCreateView()
    }
}

@available(iOS 15.0, *)
struct popularCreateView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel = Observer()
    
    @State private var activeNavigation = false

    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "type = 1"),
        animation: .default)
    private var items: FetchedResults<MovieListPopular>
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "type = 2"),
        animation: .default)
    private var items2: FetchedResults<MovieListPopular>
    
    
    @ObservedObject var monitor = NetworkMonitor()
    @ObservedObject var observed = Observer()
    
    @State var  pageCount = 1
    @State var  topRatedpageCount = 1
    
    var body: some View {
        
        if monitor.isConnected {
            
            
            NavigationView {
                
                List(observed.movieListData) { val in
                    NavigationLink(destination: MovieDetailsView(movieId: val.id ?? 0, title: val.title ?? "", lblDesc: val.overview ?? "", imageUrl: "\(Constants.imageBaseURL)\(val.posterPath ?? "")"), isActive: $activeNavigation) {
                        HStack(alignment: .center, spacing: 0) {
                            let url = "\(Constants.imageBaseURL)\(val.posterPath ?? "")"
                            WebImage(url: URL(string: url))
                                .onSuccess { image, data, cacheType in
                                }
                                .resizable()
                                .placeholder(Image(systemName: "placeholder"))
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                            VStack(alignment: .leading) {
                                let releaseDate = "Release Date : \(val.releaseDate ?? "")"
                                Text(val.title ?? "").font(.headline)
                                    .fixedSize(horizontal: false, vertical: true)
                                Divider()
                                Text(releaseDate).font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                        }
                        .onAppear {
                            addItem(id: val.id ?? 0, posterPath: val.posterPath ?? "", releaseDate: val.releaseDate ?? "", title: val.title ?? "", overview: val.overview ?? "", type: "1")
                            if observed.movieListData.last?.id == val.id ?? 0 {
                                self.pageCount += 1
                                observed.getPopularMovieList(pageno: pageCount)
                            }
                            
                        }
                        
                    }
                }
                
                .refreshable(action: {
                    await observed.reloadPopular()
                })
                .navigationBarTitle("Popular", displayMode: .large)
                .navigationViewStyle(StackNavigationViewStyle())

            }
        }
        else{
            //Offline
            
            
            NavigationView {
                
                List(items) { val in
                    NavigationLink(destination: MovieDetailsView(movieId: Int(val.id ), title: val.title ?? "", lblDesc: val.overview ?? "", imageUrl: "\(Constants.imageBaseURL)\(val.posterPath ?? "")")) {
                        HStack(alignment: .center, spacing: 0) {
                            let url = "\(Constants.imageBaseURL)\(val.posterPath ?? "")"
                            WebImage(url: URL(string: url))
                                .onSuccess { image, data, cacheType in
                                }
                                .resizable()
                                .placeholder(Image(systemName: "placeholder"))
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .scaledToFit()
                                .frame(width: 100, height: 100, alignment: .center)
                            VStack(alignment: .leading) {
                                let releaseDate = "Release Date : \(val.releaseDate ?? "")"
                                Text(val.title ?? "").font(.headline)
                                    .fixedSize(horizontal: false, vertical: true)
                                Divider()
                                Text(releaseDate).font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .padding()
                        }
                        .onAppear {
                            
                        }
                    }
                }
                .refreshable(action: {
                    await observed.reloadPopular()
                })
                
                
                .navigationBarTitle("Popular", displayMode: .large)                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            
            
        }
    }
    
    
    private func addItem(id: Int, posterPath: String, releaseDate: String, title: String, overview: String, type: String) {
        withAnimation {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityMoviePopular)
            fetchRequest.predicate = NSPredicate(format: "id = %d", id)
            var results: [NSManagedObject] = []
            do {
                results = try viewContext.fetch(fetchRequest)
                if results.first == nil{
                    let newItem = MovieListPopular(context: viewContext)
                    newItem.id = Int64(id)
                    newItem.posterPath = posterPath
                    newItem.releaseDate = releaseDate
                    newItem.title = title
                    newItem.overview = overview
                    newItem.type = type
                    
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
            catch {
                print("error executing fetch request: \(error)")
            }
            
            
            
        }
    }
}


@available(iOS 15.0, *)
struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        PopularView()
    }
}

