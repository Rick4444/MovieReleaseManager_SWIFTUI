
import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .popular
    
}


enum Page {
    case popular
    case toprated
}
