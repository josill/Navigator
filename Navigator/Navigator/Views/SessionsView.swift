//
//  LoginView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI
import SwiftData

struct SessionsView: View {
    @StateObject private var authHelper = AuthenticationHelper.shared
    @EnvironmentObject private var router: Router
    
    @State private var sessions: [Session] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Your sessions")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .onAppear {
                            Task {
                                sessions = await authHelper.getSessions() ?? []
                                isLoading = false
                            }
                        }
                    
                    Spacer()
                } else if sessions.isEmpty {
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
                    
                    Button {
                        router.changeRoute(.init(.createSession))
                    } label: {
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
                    List {
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
    
    func deleteSession(_ indexSet: IndexSet) {
        // TODO
    }
}

#Preview {
    SessionsView()
}
