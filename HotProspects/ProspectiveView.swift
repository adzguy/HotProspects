//
//  ProspectiveView.swift
//  HotProspects
//
//  Created by Davron on 2/29/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI

enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectiveView: View {
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .navigationBarTitle(title)
        }
    }
}

struct ProspectiveView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectiveView(filter: .none)
    }
}
