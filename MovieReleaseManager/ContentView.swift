//
//  ContentView.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI
import CoreData
@available(iOS 15.0, *)

struct ContentView: View {
    
    init() {
        }
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some View {
        CustomtabBarView(viewRouter: viewRouter)
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
