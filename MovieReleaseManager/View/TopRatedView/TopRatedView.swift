//
//  TopRatedView.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI
import CoreData
import SDWebImageSwiftUI
import Network

@available(iOS 15.0, *)
struct TopRatedView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
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
                
                List(observed.topRatedMovieListData) { val in
                    NavigationLink(destination: MovieDetailsView(movieId: val.id ?? 0, title: val.title ?? "", lblDesc: val.overview ?? "", imageUrl: "\(Constants.imageBaseURL)\(val.posterPath ?? "")")) {
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
                            addItem(id: val.id ?? 0, posterPath: val.posterPath ?? "", releaseDate: val.releaseDate ?? "", title: val.title ?? "", overview: val.overview ?? "", type: "2")
                            if observed.topRatedMovieListData.last?.id == val.id ?? 0 {
                                self.topRatedpageCount += 1
                                observed.getTopRatedMovieList(pageno: topRatedpageCount)
                            }
                            
                        }
                        
                    }
                }
                .refreshable(action: {
                    await observed.reloadTopRated()
                })
                .navigationBarTitle("Top Rated", displayMode: .inline)
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.barTintColor = .blue
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                })
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        } else {
            
            NavigationView {
                
                List(items2) { val in
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
                    await observed.reloadTopRated()
                })
                .navigationBarTitle("Top Rated", displayMode: .inline)
                .background(NavigationConfigurator { nc in
                    nc.navigationBar.barTintColor = .blue
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                })
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    
    private func addItem(id: Int, posterPath: String, releaseDate: String, title: String, overview: String, type: String) {
        withAnimation {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieListPopular")
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
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
struct TopRatedView_Previews: PreviewProvider {
    static var previews: some View {
        TopRatedView()
    }
}
