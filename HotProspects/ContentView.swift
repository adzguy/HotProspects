//
//  ContentView.swift
//  HotProspects
//
//  Created by Davron on 2/23/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI
import SamplePackage

struct ContentView: View {
    var prospects = Prospects()
    
    var body: some View {
        TabView {
            ProspectiveView(filter: .none)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Everyone")
                }
            ProspectiveView(filter: .contacted)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Contacted")
                }
            ProspectiveView(filter: .uncontacted)
                .tabItem {
                    Image(systemName: "questionmark.diamond")
                    Text("Uncontacted")
                }
            MeView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Me")
            }
        }.environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
