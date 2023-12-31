//
//  AuthenticationHelper.swift
//  Navigator
//
//  Created by Jonathan Sillak on 28.11.2023.
//

import Foundation
import CryptoKit
import MapKit
import SwiftData

class AuthenticationHelper: ObservableObject {
    static let shared = AuthenticationHelper()
    let config = Configuration()
    
    @Published var savedUser: User? = nil
    @Published var savedSessionId: String? = nil
    
    @Published var isLoading = false
    
    @Published var firstNameError = ""
    @Published var lastNameError = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var passwordsError = ""
    
    @Published var loginError = ""
    @Published var registerError = ""
    
    @Published var createSessionSuccess = false
    @Published var quitSessionPresented = false
    
    @Published var sessionNameError = false
    @Published var sessionDescriptionError = false
    
    enum GpsSessionType { case walking, running }
    enum LocationType { case location, checkPoint, wayPoint }
    
    init() {
        if let user = UserDefaults.standard.data(forKey: "savedUser"),
           let loadedUser = try? JSONDecoder().decode(User.self, from: user) {
            self.savedUser = loadedUser
        }
        
        if let sessionId = UserDefaults.standard.string(forKey: "savedSessionId") {
            self.savedSessionId = sessionId
        }
    }
    
    func validateNames(_ firstName: String, _ lastName: String) -> Bool {
        let firstNameCorrect = firstName.count > 3
        let lastNameCorrect = lastName.count > 3
        
        if firstNameCorrect { firstNameError = "" }
        else { firstNameError = "First name is too short!" }
        
        if lastNameCorrect { lastNameError = "" }
        else { lastNameError = "Last name is too short!" }
        
        return firstNameCorrect && lastNameCorrect
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let emailCorrect = emailPredicate.evaluate(with: email)
        
        if (emailCorrect) { emailError = "" }
        else { emailError = "Email is not valid!" }
        
        return emailCorrect
    }
    
    func passwordMeetsRequirements(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{4,}$"
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return passwordPredicate.evaluate(with: password)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordCorrect = passwordMeetsRequirements(password)
        
        if passwordCorrect { passwordError = "" }
        else { passwordError = """
            Password doesnt contain:
            - one lowercase letter
            - one uppercase letter
            - one number
            - one symbol
            """ }
        
        return passwordCorrect
    }
    
    func validatePasswords(_ password1: String, _ password2: String) -> Bool {
        let passwordsCorrect =
        password1 == password2 &&
        validatePassword(password1)
        
        if passwordsCorrect { passwordsError = "" }
        else if password1 != password2 { passwordsError = "Passwords don't match!" }
        
        return passwordsCorrect
    }
    
    func register(firstName: String, lastName: String, email: String, password1: String, password2: String) async -> Bool {
        isLoading = true
        
        if !validateNames(firstName, lastName) { isLoading = false; return false }
        if !validateEmail(email) { isLoading = false; return false }
        if !validatePasswords(password1, password2) { isLoading = false; return false }
        
        let urlString = "\(config.baseUrl)/api/v1.0/account/register"
        let data = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password1,
        ]
        
        guard let url = URL(string: urlString) else {
            registerError = "Something went wrong!"
            print("unable to make string: \(urlString) to URL object")
            isLoading = false
            return false
        }
        guard let encoded = try? JSONEncoder().encode(data) else {
            registerError = "Something went wrong!"
            print("Failed to encode data: \(data)")
            isLoading = false
            return false
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                registerError = "Something went wrong!"
                print("Invalid response")
                isLoading = false
                return false
            }
            
            if res.statusCode == 200 {
                // Process the successful response
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    guard let token = json["token"] else {
                        isLoading = false
                        registerError = "Something went wrong!"
                        return false
                    }
                    
                    print("register success")
                    isLoading = false
                    registerError = ""
                    return true
                    
                }
            } else if res.statusCode == 404 {
                registerError = "User with this email already exists!"
                isLoading = false
            } else {
                registerError = "Something went wrong!"
                print("HTTP Status Code: \(res.statusCode)")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                } else {
                    print("Failed to convert response data to string.")
                }
            }
        } catch {
            registerError = "Something went wrong!"
            print("Error: \(error)")
            return false
        }
        
        isLoading = false        
        return false
    }
    
    func login(email: String, password: String) async -> Bool {
        isLoading = true
        
        if !validateEmail(email) { isLoading = false; return false }
        
        if !validatePassword(password) { isLoading = false; return false }
        
        let urlString = "\(config.baseUrl)/api/v1.0/account/login"
        let data = [
            "email": email,
            "password": password
        ]
        
        guard let url = URL(string: urlString) else {
            loginError = "Something went wrong!"
            print("unable to make string: \(urlString) to URL object")
            isLoading = false
            return false
        }
        guard let encoded = try? JSONEncoder().encode(data) else {
            loginError = "Something went wrong!"
            print("Failed to encode data: \(data)")
            isLoading = false
            return false
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                loginError = "Something went wrong!"
                print("Invalid response")
                isLoading = false
                return false
            }
            
            if res.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let token = json["token"] as! String
                    
                    Task { @MainActor in
                        savedUser = User(
                            email: email,
                            password: password,
                            jwtToken: token
                        )
                        if let encodedUser = try? JSONEncoder().encode(savedUser) {
                            UserDefaults.standard.set(encodedUser, forKey: "savedUser")
                        }
                    }
                    
                    isLoading = false
                    return true
                }
            } else {
                loginError = "Wrong email or password!"
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
            loginError = "Something went wrong!"
            print("Error: \(error)")
        }
        
        isLoading = false
        return false
    }
    
    func logOut(completion: @escaping () -> Void) {
        savedUser = nil
        UserDefaults.standard.removeObject(forKey: "savedUser")
        print("logout: \(savedUser)")
        completion()
    }
    
    func createSession(name: String, description: String, mode: GpsSessionType) async {
        Task { @MainActor in
            isLoading = true
        }
        
        if name == "" {
            sessionNameError = true
            isLoading = false
            return
        } else if description == "" {
            sessionDescriptionError = true
            isLoading = false
            return
        }
        
        let urlString = "\(config.baseUrl)/api/v1.0/GpsSessions"
        let minSpeed = mode == .walking ? 360.0 : 360.0
        let maxSpeed = mode == .walking ? 720.0 : 600.0
        let data = [
            "name": name,
            "description": description,
            "gpsSessionTypeId": mode == .walking ? "00000000-0000-0000-0000-000000000003" : "00000000-0000-0000-0000-000000000001",
            "paceMin": minSpeed,
            "paceMax": maxSpeed,
        ] as [String: Any]
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            isLoading = false
            return
        }
        
        guard let encoded = try? JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            print("Failed to encode data: \(data)")
            isLoading = false
            return
        }
        
        guard let token = savedUser?.jwtToken else {
            print("Failed to receive token: \(savedUser)")
            isLoading = false
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                isLoading = false
                return
            }
            
            if res.statusCode == 201 {
                print("session created successfully")
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    guard let userId = json["appUserId"] as? String,
                          let sessionId = json["id"] as? String else {
                        print("Error getting data from json: \(json)")
                        isLoading = false
                        return
                    }
                    
                    Task { @MainActor in
                        UserDefaults.standard.set(sessionId, forKey: "savedSessionId")
                        savedSessionId = sessionId
                        
                        if savedSessionId != nil {
                            isLoading = false
                            createSessionSuccess = true
                        }
                    }
                } else {
                    print("Error inserting session to db")
                    isLoading = false
                    return
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
        
        Task { @MainActor in
            isLoading = false
        }
    }
    
    func getSessions() async -> [Session]? {
        let urlString = "\(config.baseUrl)/api/v1.0/GpsSessions"
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            return nil
        }
        
        //        guard let token = savedUser?.jwtToken else {
        //            print("Failed to receive token: \(savedUser)")
        //            return nil
        //        }
        
        var req = URLRequest(url: url)
        //        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                return nil
            }
            
            if res.statusCode == 200 {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let sessions = try decoder.decode([Session].self, from: data)
                    
                    return sessions
                } catch {
                    print("Error decoding JSON: \(error)")
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
        
        return nil
    }
    
    func presentQuitSessionAlert() {
        quitSessionPresented.toggle()
    }
    
    func quitSavedSession() {
        savedSessionId = nil
        UserDefaults.standard.removeObject(forKey: "savedSessionId")
        print("Saved session is \(savedSessionId)")
    }
    
    func updateLocation(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        locationType: LocationType
    ) async {
        if savedSessionId == nil { return }
        
        let urlString = "\(config.baseUrl)/api/v1.0/gpsLocations"
        let locTypeId = locationType == .location ? "00000000-0000-0000-0000-000000000001" : locationType == .wayPoint ? "00000000-0000-0000-0000-000000000002" : "00000000-0000-0000-0000-000000000003"
        let data = [
            "gpsSessionId": savedSessionId!,
            "gpsLocationTypeId": locTypeId,
            "latitude": latitude,
            "longitude": longitude,
        ] as [String: Any]
        
        if locationType != .location {
            print("data: \(data)")
        }
        
        guard let url = URL(string: urlString) else {
            print("unable to make string: \(urlString) to URL object")
            isLoading = false
            return
        }
        
        guard let encoded = try? JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            print("Failed to encode data: \(data)")
            isLoading = false
            return
        }
        
        guard let token = savedUser?.jwtToken else {
            print("Failed to receive token: \(savedUser)")
            isLoading = false
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: req, from: encoded)
            
            guard let res = response as? HTTPURLResponse else {
                print("Invalid response")
                isLoading = false
                return
            }
            
            if res.statusCode == 201 {
                print("location updated successfully")
                
                if locationType != .location {
                    print("respone: \(data)")
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    print("json from location: \(json)")
                    
                    return
                } else {
                    print("Error inserting session to db")
                    return
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
        
        return
    }
}

extension Data {
    static func random(count: Int) -> Data {
        var data = Data(count: count)
        _ = data.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress!) }
        return data
    }
}
