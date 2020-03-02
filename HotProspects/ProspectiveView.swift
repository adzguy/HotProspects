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
    @EnvironmentObject var prospects: Prospects
    
    var body: some View {
        NavigationView {
            Text("People: \(prospects.people.count)")
                .navigationBarTitle(title)
                .navigationBarItems(trailing: Button(action: {
                    let prospect = Prospect()
                    prospect.name = "Paul Hudson"
                    prospect.emailAddress = "paul@hackingwithswift.com"
                    self.prospects.people.append(prospect)
                }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
        }
    }
}

struct ProspectiveView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectiveView(filter: .none)
    }
}
