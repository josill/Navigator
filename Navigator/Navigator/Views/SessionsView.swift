//
//  LoginView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import SwiftData

struct SessionsView: View {
    @Environment (\.modelContext) var modelContext
    
    @ObservedObject var authHelper = AuthenticationHelper()
    @Query(sort: [SortDescriptor(\Session.createdAt)]) var sessions: [Session]
    @State private var searchText = ""
    private var currentUser = DatabaseService.shared.currentUser
    
    init() {
        _sessions = Query(
            filter: #Predicate {
                if let user = $0.user {
                    if user.email == currentUser!.email { return true }
                    else { return false }
                }
                else { return false }
            },
            sort: [SortDescriptor(\Session.createdAt)]
        )
        
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack {
                            Text("Your sessions")
                                                        
                            Text("\(currentUser?.firstName ?? "w")")
                        }
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    if sessions.isEmpty {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title2)
                                .foregroundColor(.red)
                                .padding(.top, 10)
                            
                            Text("No sessions available.")
                                .font(.title2)
                                .foregroundColor(.red)
                                .padding(.top, 10)
                        }
                        .padding(.bottom, 30)
                        
                        Button("New session") {
                            print("create session")
                        }
                        .frame(maxWidth: 265)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white.opacity(0.9))
                        .font(.headline)
                        .cornerRadius(12.0)
                        
                        Spacer()
                    } else {
                        
                        List{
                            ForEach(sessions) { session in
                                SessionLink(session: session)
                            }
                            .onDelete(perform: deleteSession)
                        }
                        .background(.black)
                        .scrollContentBackground(.hidden)
                    }
                }
                .background(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .searchable(text: $searchText)
        }
    }
    
    func deleteSession(_ indexSet: IndexSet) {
        for i in indexSet {
            let session = sessions[i]
            modelContext.delete(session)
        }
    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Session.self, configurations: config)
        let context = ModelContext(container)
//        let exampleSessions = [
//            Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 1", createdAt: Date(), distanceCovered: 10.5, timeElapsed: 3600, averageSpeed: 5.0, checkPoints: [], wayPoints: [], locations: []),
//            Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 2", createdAt: Date(), distanceCovered: 15.7, timeElapsed: 4500, averageSpeed: 7.0, checkPoints: [], wayPoints: [], locations: []),
//            Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 3", createdAt: Date(), distanceCovered: 8.2, timeElapsed: 3000, averageSpeed: 4.0, checkPoints: [], wayPoints: [], locations: []),
//            Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 4", createdAt: Date(), distanceCovered: 20.1, timeElapsed: 6000, averageSpeed: 6.7, checkPoints: [], wayPoints: [], locations: []),
//            Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 5", createdAt: Date(), distanceCovered: 12.3, timeElapsed: 4200, averageSpeed: 5.8, checkPoints: [], wayPoints: [], locations: [])
//        ]
//        context.insert(exampleSessions[0])
//        context.insert(exampleSessions[1])
//        context.insert(exampleSessions[2])
//        context.insert(exampleSessions[3])
//        context.insert(exampleSessions[4])
        return SessionsView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
