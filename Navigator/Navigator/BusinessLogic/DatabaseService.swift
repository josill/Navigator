////
////  DatabaseService.swift
////  Navigator
////
////  Created by Jonathan Sillak on 10.12.2023.
////
//
//import Foundation
//import SwiftData
//import CryptoKit
//
//class DatabaseService: ObservableObject {
//    static var shared = DatabaseService()
//    var container: ModelContainer?
//    var context: ModelContext?
//    
//    @Published var currentUserStored: User?
//    @Published var currentSession: Session?
//    
//    init() {
//        self.currentUserStored = loadCurrentUserFromUserDefaults()
//    }
//    
//    var currentUser: User? {
//        get {
//            return currentUserStored
//        }
//        set {
//            if let encoded = try? JSONEncoder().encode(newValue) {
//                UserDefaults.standard.set(encoded, forKey: "currentUser")
//                currentUserStored = newValue
//            } else {
//                currentUserStored = nil
//            }
//        }
//    }
//    
//    func setContext(modelContainer: ModelContainer) {
//        container = modelContainer
//        
//        if let container = container {
//            context = ModelContext(container)
//        }
//    }
//    
//    private func loadCurrentUserFromUserDefaults() -> User? {
//        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
//           let user = try? JSONDecoder().decode(User.self, from: userData) {
//            return user
//        }
//        return nil
//    }
//    
//    func saveUser(
//        firstName: String? = nil,
//        lastName: String? = nil,
//        email: String,
//        password: String
//    ) -> User? {
//        let salt = generateSalt()
//        let passwordHash = hashPassword(password: password, salt: salt)
//        
//        let user = User(
//            firstName: firstName,
//            lastName: lastName,
//            email: email,
//            salt: salt,
//            passwordHash: passwordHash
//        )
//        
//        context!.insert(user)
//        
//        do {
//            try context!.save()
//            
//            return user
//        } catch {
//            print("Error updating db in saveUser method: \(error)")
//        }
//        
//        return nil
//    }
//    
//    func saveSession(
//        sessionId id: String,
//        sessionName: String,
//        sessionDescription: String,
//        minSpeed: Double,
//        maxSpeed: Double
//    ) -> Session? {
//        guard let id = UUID(uuidString: id) else {
//            print("Error generating UUID in saveSession method")
//            return nil
//        }
//        
//        let session = Session(
//            sessionId: id,
//            sessionName: sessionName,
//            sessionDescription: sessionDescription,
//            minSpeed: minSpeed,
//            maxSpeed: maxSpeed
//        )
//        
//        context!.insert(session)
//        
//        do {
//            try context!.save()
//            currentSession = session
//            
//            return session
//        } catch {
//            print("Error updating db in saveSession method: \(error)")
//        }
//        
//        return nil
//    }
//    
//    func updateJwt(email: String, jwt: String) -> User? {
//        var updatedUser: User?
//        
//        getAllUsers { users in
//            for user in users {
//                if user.email.lowercased() == email.lowercased() {
//                    user.jwtToken = jwt
//                    self.currentUser = user
//                    print("JWT updated for user: \(user.email)")
//                    print("currentUser: \(self.currentUser)")
//                    updatedUser = user
//                    break
//                }
//                print("JWT update user email: \(user.email) and our email: \(email)")
//            }
//        }
//        
//        return updatedUser
//    }
//    
//    func removeCurrentUser() -> User? {
//        if let user = currentUserStored {
//            currentUser = nil
//        }
//        
//        return nil
//    }
//    
//    func getUser(email: String, completion: @escaping (User?) -> Void) {
//        var descriptor = FetchDescriptor<User>(predicate: #Predicate {
//            return $0.email == email
//        })
//        
//        do {
//            let users = try context!.fetch(descriptor)
//            if let user = users.first {
//                completion(user)
//            } else {
//                completion(nil)
//            }
//        } catch {
//            print("Error fetching user: \(error)")
//            completion(nil)
//        }
//    }
//    
//    func getSession(id: UUID, completion: @escaping (Session?) -> Void) {
//        var descriptor = FetchDescriptor<Session>(predicate: #Predicate {
//            return $0.sessionId == id
//        })
//        
//        do {
//            let sessions = try context!.fetch(descriptor)
//            if let session = sessions.first {
//                completion(session)
//            } else {
//                completion(nil)
//            }
//        } catch {
//            print("Error fetching session: \(error)")
//            completion(nil)
//        }
//    }
//    
//    func getAllUsers(completion: @escaping ([User]) -> Void) {
//        let descriptor = FetchDescriptor<User>()
//        
//        do {
//            let users = try context!.fetch(descriptor)
//            completion(users)
//        } catch {
//            completion([])
//        }
//    }
//}
