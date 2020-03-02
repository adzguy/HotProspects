//
//  Prospect.swift
//  HotProspects
//
//  Created by Davron on 3/1/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var isContacted = false
}

class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        self.people = []
    }
}
