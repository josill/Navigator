//
//  LoginView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import SwiftData

struct SessionsView: View {
    
    @ObservedObject var authHelper = AuthenticationHelper()
    
    @Query(
//        filter: #Predicate {
//                guard let user = $0.user else {
//                    return false
//                }
//
//                return DatabaseService.shared.currentUser?.email == user.email
//            },
            sort: [SortDescriptor(\Session.createdAt)]
        ) var sessions: [Session]

//    init() {
//        _sessions = Query(
//            filter: #Predicate {
//                if let user = $0.user {
//                    if user.email == currentUser!.email { return true }
//                    else { return false }
//                }
//                else { return false }
//            },
//            sort: [SortDescriptor(\Session.createdAt)]
//        )
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack {
                            Text("Your sessions")
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
                        
                    NavigationLink(destination: CreateSessionView()) {
                            Text("Create session")
                        }
                        .frame(maxWidth: 265)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white.opacity(0.9))
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
        }
        .onAppear() {
            Task {
                var sessions = await authHelper.getSessions()
                
                print("Sessions: \(sessions)")
            }
        }
    }
    
    func deleteSession(_ indexSet: IndexSet) {
        // TODO
    }
}

#Preview {
    return SessionsView()
}
