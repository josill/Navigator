//
//  AuthenticationHelper.swift
//  Navigator
//
//  Created by Jonathan Sillak on 28.11.2023.
//

import Foundation
import CryptoKit
import SwiftData

class AuthenticationHelper: ObservableObject {
    let config = Configuration()
    
    var dbService = DatabaseService.shared
    
    @Published var isLoading = false
    
    @Published var firstNameError = false
    @Published var lastNameError = false
    @Published var emailError = false
    @Published var passwordError = false
    @Published var passwordsError = false
    
    @Published var registerSuccessful = false;
    @Published var loginSuccessful = false;
    
    func validateNames(firstName: String, lastName: String) -> Bool {
        let firstNameCorrect = firstName.count > 3
        let lastNameCorrect = lastName.count > 3
        
        if firstNameCorrect { firstNameError = false }
        else { firstNameError = true }
        
        if lastNameCorrect { lastNameError = false }
        else { lastNameError = true }
        
        return firstNameCorrect && lastNameCorrect
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let emailCorrect = emailPredicate.evaluate(with: email)
        
        if (emailCorrect) { emailError = false }
        else { emailError = true }
        
        return emailCorrect
    }
    
    func passwordMeetsRequirements(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{4,}$"
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return passwordPredicate.evaluate(with: password)
    }
    
    func validatePassword(password: String) -> Bool {
        let passwordCorrect = password.count > 3
        
        if passwordCorrect { passwordError = false }
        else { passwordError = true }
        
        return passwordCorrect
    }
    
    func validatePasswords(password1: String, password2: String) -> Bool {
        let passwordsCorrect =
        password1 == password2 &&
        passwordMeetsRequirements(password1)
        
        if (passwordsCorrect) { passwordsError = false }
        else { passwordsError = true }
        
        return passwordsCorrect
    }
    
    //    func fetchUser(email: String) async throws -> [User] {
    //        do {
    //            
    ////            let fetchDescriptor = FetchDescriptor(predicate: #Predicate { (user: User) in
    ////                user.email == email
    ////            })
    ////            let fetchDescriptor = Query()
    ////            let user = try self.context.fetch(fetchDescriptor)
    //            @Query var users = Query<User>()
    //            
    //            user.forEach { user in
    //                print("User ID: \(user.id)")
    //            }
    //            
    //            print("user fetched")
    //            return user
    //        } catch {
    //            print("Failed to fetch users: \(error)")
    //            throw error
    //        }
    //    }
    
    func register(firstName: String, lastName: String, email: String, password1: String, password2: String) async {
        isLoading = true
        
        let namesCorrect = validateNames(firstName: firstName, lastName: lastName)
        let emailCorrect = validateEmail(email: email)
        let passwordsMatch = validatePasswords(password1: password1, password2: password2)
        
        if !namesCorrect || !emailCorrect || !passwordsMatch { 
            isLoading = false
            return
        }
        
        let urlString = "\(config.baseUrl)/api/v1.0/account/register"
        let data = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password1,
        ]
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            return
        }
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("Failed to encode data: \(data)")
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if res.statusCode == 200 {
                // Process the successful response
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["token"] as? String {
                    print("Token: \(token)")
                    
                    registerSuccessful = true
                    dbService.saveUser(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password1
                    )
                }
            } else {
                print("HTTP Status Code: \(res.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    // Handle the error using the responseString
                } else {
                    print("Failed to convert response data to string.")
                    // Handle the error appropriately
                }
                // Handle the error appropriately
            }
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        
        let emailCorrect = validateEmail(email: email)
        let passwordValid = validatePassword(password: password)
        
        print(emailCorrect)
        print(passwordValid)
        
        if !emailCorrect && !passwordValid {
            isLoading = false
            return
        }
        
        let urlString = "\(config.baseUrl)/api/v1.0/account/login"
        let data = [
            "email": email,
            "password": password
        ]
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            return
        }
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("Failed to encode data: \(data)")
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if res.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["token"] as? String {
                    print("Token: \(token)")
                    
                    loginSuccessful = true
                    dbService.updateJwt(
                        email: email,
                        jwt: token
                    )
                }
            } else {
                print("HTTP Status Code: \(res.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    // Handle the error using the responseString
                } else {
                    print("Failed to convert response data to string.")
                    // Handle the error appropriately
                }
                // Handle the error appropriately
            }
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
    }
}

extension Data {
    static func random(count: Int) -> Data {
        var data = Data(count: count)
        _ = data.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress!) }
        return data
    }
}
