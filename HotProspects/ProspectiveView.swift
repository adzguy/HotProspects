//
//  ProspectiveView.swift
//  HotProspects
//
//  Created by Davron on 2/29/20.
//  Copyright © 2020 Davron. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}

enum FilterBy {
    case name, date
}

struct ProspectiveView: View {
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var showingActionSheet = false
    @State private var filterBy: FilterBy = .name
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
    
    var filteredProspects: [Prospect] {
        let filteredList = filterBy == .name ? prospects.people.sorted { $0.name < $1.name} : prospects.people.sorted { $0.date > $1.date}
        switch filter {
        case .none:
            return filteredList
        case .contacted:
            return filteredList.filter { $0.isContacted }
        case .uncontacted:
            return filteredList.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        Image(systemName: prospect.isContacted ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(prospect.isContacted ? .green : .red)
                            
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                            
                        }
                        .contextMenu {
                            Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
                                self.prospects.toggle(prospect)
                            }
                            
                            if !prospect.isContacted {
                                Button("Remind Me") {
                                    self.addNotification(for: prospect)
                                }
                            }
                        }
                    }
                }
            }
                .navigationBarTitle(title)
                .navigationBarItems(leading: Button(action: {
                    self.showingActionSheet = true
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                },
                trailing: Button(action: {
                    self.isShowingScanner = true

                }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Change order"), buttons: [
                    .default(Text("By Name")) { self.filterBy = .name},
                    .default(Text("By Date")) { self.filterBy = .date},
                    .cancel()
                ])
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]

            self.prospects.add(person)
            
        case .failure( _):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            //content.subtitle = prospect.emailAddress
            content.subtitle = "Give him a chance!"
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectiveView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectiveView(filter: .none)
    }
}
