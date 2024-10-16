//
//  ContentView.swift
//  Milestone_Projects_10_12
//
//  Created by user09 on 19.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\User.name),
                  SortDescriptor(\User.age)
                 ]) var users: [User]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(users) { user in
                        NavigationLink(value: user) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(user.name)
                                    Text(user.email)
                                }
                                Spacer()
                                Text(user.isActive ? "Online" : "Offline")
                                    .foregroundStyle(user.isActive ? .green : .red)
                            }
                        }
                    }
                }
                ProgressView()
                    .progressViewStyle(.circular)
                    .opacity(users.isEmpty ? 1 : 0)
            }
            .navigationTitle("List of users")
            .navigationDestination(for: User.self) { user in
                Form {
                    Section("User info") {
                        Text(user.name)
                        Text("Age \(user.address)")
                        Text(user.email)
                        Text(user.company)
                        Text(user.address)
                        Text(user.registered.formatted(date: .abbreviated, time: .omitted))
                        Text(user.about)
                    }
                    Section("Friends") {
                        Text(getFriendsName(firends: user.friends))
                    }
                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear(perform: {
            Task {
                await getUsers()
            }
        })
    }
    
    func getFriendsName(firends: [Friend]) -> String {
        var firendsName = ""
        for friend in firends {
            firendsName += "\(friend.name) \n"
        }
        return firendsName
    }
    
    func getUsers() async {
        guard users.isEmpty else {
            return
        }
        do {
            let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let users: [User] = try await URLSession.shared.decode(from: url, dateDecodingStrategy: .iso8601)
            self.saveUsers(users: users)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func saveUsers(users: [User]) {
        for user in users {
            self.modelContext.insert(user)
        }
    }
}

#Preview {
    ContentView()
}
