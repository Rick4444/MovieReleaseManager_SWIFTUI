//
//  MovieDetailsView.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreData


struct MovieDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var movieId = 0
    var title = ""
    var lblDesc = ""
    var imageUrl = ""
    let targetSize = CGSize(width: UIScreen.main.bounds.size.width - 80, height: UIScreen.main.bounds.size.height / 2.9)
    @ObservedObject var observed = Observer()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)],
        animation: .default)
    var items: FetchedResults<MovieComment>
    
    
    @State var resultsData : [String] = []
    init(movieId: Int, title: String, lblDesc: String, imageUrl: String) {
        self.movieId = movieId
        self.title = title
        self.lblDesc = lblDesc
        self.imageUrl = imageUrl
    }
    
    @State var comment: String = ""
    
    @State private var showText = false
    
    
    var body: some View {
        NavigationView {
            List() {
                VStack(alignment: .leading) {
                    WebImage(url: URL(string: imageUrl))
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
                        .frame(width: targetSize.width, height: targetSize.height, alignment: .center)
                    
                    Text(title).font(.title).fixedSize(horizontal: false, vertical: true)
                    Divider()
                    Text(lblDesc)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                    Divider()
                    HStack {
                        Button("Watch Trailer") {
                            if let youtubeURL = URL(string: "youtube://\(observed.movieTralerLink[0].Key ?? "")"),
                               UIApplication.shared.canOpenURL(youtubeURL) {
                                // redirect to app
                                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                            } else if let youtubeURL = URL(string: "\(Constants.youTubeVideoLink)\(observed.movieTralerLink[0].Key ?? "")") {
                                // redirect through safari
                                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                            }
                        }
                        .buttonStyle(GrowingButton())
                        .padding(.horizontal, 8).lineLimit(1).minimumScaleFactor(0.4)
                        
                        VStack {
                            Button("Add Comment") {
                                showText.toggle()
                            }
                            .buttonStyle(GrowingButton())
                            .padding(.horizontal, 8).lineLimit(1).minimumScaleFactor(0.4)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        let txt = "Total Comments (\(resultsData.count))"
                        Text(txt)
                            .font(.headline)
                        Divider()
                            .padding()
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        ForEach(0..<resultsData.count, id: \.self) { data in
                            Text("\(resultsData[data])")
                                .font(.subheadline)
                            Divider()
                                .padding()
                        }
                    }.padding(.leading, 10)
                    
                    
                    if showText {
                        TextField("Comment here", text: $comment, onEditingChanged: { (changed) in
                            if comment != "" {
                                addComment(comment: comment)
                                showText.toggle()
                            }
                            
                        }) {
                        }
                        .padding()
                    }
                    
                    Spacer()
                } .onAppear(){
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityComment)
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                    fetchRequest.predicate = NSPredicate(format: "movieid = \(movieId)" )
                    var results: [NSManagedObject] = []
                    do {
                        results = try viewContext.fetch(fetchRequest)
                        resultsData.removeAll()
                        for val in results {
                            resultsData.append(val.value(forKey: "comment") as! String)
                        }
                        //
                    } catch {
                        print("error executing fetch request: \(error)")
                    }
                }
            }.onAppear(){
                observed.getMovieData(id: movieId)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    private func addComment(comment: String) {
        withAnimation {
            resultsData.append(comment)
            let newItem = MovieComment(context: viewContext)
            newItem.id = Int64(items.count + 1)
            newItem.comment = comment
            newItem.movieid = Int64(movieId)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    
    
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movieId: 0, title: "", lblDesc: "", imageUrl: "")
    }
}



struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
