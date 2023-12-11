//
//  DatabaseService.swift
//  Navigator
//
//  Created by Jonathan Sillak on 10.12.2023.
//

import Foundation
import SwiftData
import CryptoKit

class DatabaseService: ObservableObject {
    static var shared = DatabaseService()
    var container: ModelContainer?
    var context: ModelContext?
    
    var currentUser: User? {
        get {
            if let userData = UserDefaults.standard.data(forKey: "currentUser"),
               let user = try? JSONDecoder().decode(User.self, from: userData) {
                return user
            }
            
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "currentUser")
            }
        }
    }
    
    init() {
        do {
            print("init modelcontainer")
            container = try ModelContainer(for: User.self, Session.self, UserLocation.self)
            if let container = container {
                context = ModelContext(container)
            }
        } catch {
            print("Error setting up the database: \(error)")
        }
    }
    
    private func generateSalt() -> String {
        let randomData = Data.random(count: 16)
        return randomData.base64EncodedString()
    }
    
    private func hashPassword(password: String, salt: String) -> String {
        let saltedPassword = password + salt
        let passwordData = Data(saltedPassword.utf8)
        let hashed = SHA256.hash(data: passwordData)
        return hashed.compactMap { String(format: "%02hhx", $0) }.joined()
    }
    
    func saveUser(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) {
        let salt = generateSalt()
        let passwordHash = hashPassword(password: password, salt: salt)
        
        let user = User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            salt: salt,
            passwordHash: passwordHash
        )
        
        context!.insert(user)
        
        do {
            try context!.save()
        } catch {
            print("Error updating db: \(error)")
        }
    }
    
    func updateJwt(email: String, jwt: String) {
        var _: () = getAllUsers { users in
            for user in users {
                if user.email == email {
                    user.jwtToken = jwt
                    self.currentUser = user
                    print("jwt updated successfully")
                }
                print(user)
            }
            print("All users: \(users)")
        }
    }
    
    func getUser(email: String, completion: @escaping (User?) -> Void) {
        var descriptor = FetchDescriptor<User>(predicate: #Predicate {
            return $0.email == email
        })
        do {
            let users = try context!.fetch(descriptor)
            if let user = users.first {
                completion(user)
            } else {
                completion(nil)
            }
        } catch {
            print("Error fetching user: \(error)")
            completion(nil)
        }
    }
    
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        let descriptor = FetchDescriptor<User>()
        
        do {
            let users = try context!.fetch(descriptor)
            completion(users)
        } catch {
            completion([])
        }
    }
}