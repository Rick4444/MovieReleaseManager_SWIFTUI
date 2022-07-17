//
//  ContentView.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject var viewRouter = ViewRouter()
        
    var body: some View {
        CustomtabBarView(viewRouter: viewRouter)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
