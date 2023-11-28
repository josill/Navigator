//
//  AuthenticationHelper.swift
//  Navigator
//
//  Created by Jonathan Sillak on 28.11.2023.
//

import Foundation

class AuthenticationHelper: ObservableObject {
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
    
    func validatePassword(password: String) -> Bool {
        let passwordCorrect = password.count > 3
        
        if passwordCorrect { passwordError = false }
        else { passwordError = true }
        
        return passwordCorrect
    }
    
    func validatePasswords(password1: String, password2: String) -> Bool {
        let passwordsCorrect =
        password1 == password2 &&
        password1.count > 3 &&
        password2.count > 3
        
        if (passwordsCorrect) { passwordsError = false }
        else { passwordsError = true }
        
        return passwordsCorrect
    }
    
    func register(firstName: String, lastName: String, email: String, password1: String, password2: String) {
        let namesCorrect = validateNames(firstName: firstName, lastName: lastName)
        let emailCorrect = validateEmail(email: email)
        let passwordsMatch = validatePasswords(password1: password1, password2: password2)
        
        if !namesCorrect || !emailCorrect || !passwordsMatch { return }
        registerSuccessful = true
    }
    
    func login(email: String, password: String) {
        let emailCorrect = validateEmail(email: email)
        let passwordsMatch = validatePassword(password: password)
        
        if !emailCorrect || !passwordsMatch { return }
        loginSuccessful = true
    }
}
