//
//  CustomtabBarView.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI

struct CustomtabBarView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    @State var showPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .popular:
                    PopularView()
                case .toprated:
                    TopRatedView()
                }
                Spacer()
                
                HStack {
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .popular, width: geometry.size.width/2, height: geometry.size.height/28, systemIconName: "popular", tabName: "Popular")
                    TabBarIcon(viewRouter: viewRouter, assignedPage: .toprated, width: geometry.size.width/2, height: geometry.size.height/28, systemIconName: "toprated", tabName: "Top Rated")
                }
                .frame(width: geometry.size.width, height: geometry.size.height/8)
                .background(Color("TabBarBackground").shadow(radius: 2))
                
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            Image(systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color("TabBarHighlight") : .gray)
    }
}


struct CustomtabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomtabBarView(viewRouter: ViewRouter())
            .preferredColorScheme(.light)

    }
}
