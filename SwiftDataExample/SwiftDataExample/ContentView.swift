//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by Jonathan Sillak on 04.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Session.recordedAt) var sessions: [Session]
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button {
                add()
            } label: {
                Text("Click me!")
            }
            
            List {
                ForEach(sessions) { session in
                    /*@START_MENU_TOKEN@*/Text(session.name)/*@END_MENU_TOKEN@*/
                }
                .onDelete{ indexSet in
                    for i in indexSet {
                        context.delete(sessions[i])
                    }
                }
            }
        }
        .padding()
    }
    
    func add() {
        let sess = Session(
            id: UUID(),
            name: "Session test",
            description: "desc",
            recordedAt: Date(),
            duration: 10.0,
            speed: 4.5,
            distance: 2800.0
        )
        
        context.insert(sess)
        try! context.save()
    }
    
    func update() {
        
    }
}

#Preview {
    ContentView()
}
