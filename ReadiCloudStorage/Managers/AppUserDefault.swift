//
//  Created by Dushan Saputhanthri on 15/6/18.
//  Copyright © 2018 RYRA Circuit. All rights reserved.
//

import Foundation

struct AppUserDefault {
    
    static let shared = UserDefaults.standard
    
    //MARK: FCM token
    /// Set FCM Token
    static func setFCMToken(token: String) {
        shared.set(token, forKey: "FCM_TOKEN")
        shared.synchronize()
    }
    
    /// Get FCM Token
    static func getFCMToken() -> String {
        if let token = shared.string(forKey: "FCM_TOKEN") {
            return token
        }
        return ""
    }
    
    
    //MARK: ACCESS TOKEN
    /// Set Access Token
    static func setAccessToken(token: String) {
        shared.set(token, forKey: "ACCESS_TOKEN")
        shared.synchronize()
    }
    
    /// Get Access Token
    static func getAccessToken() -> String {
        if let token = shared.string(forKey: "ACCESS_TOKEN") {
            return token
        }
        return ""
    }
    
    /// Remove Access Token
    static func removeAccessToken() {
        
        let token = self.getAccessToken()
        
        if !(token.isEmpty) {
            shared.removeObject(forKey: "ACCESS_TOKEN")
        }
    }
    
    
    //MARK: User Credentials
    /// Set User Credentials
    static func setUserCredentials(credentails: [String: Any]) {
        shared.set(credentails, forKey: "USER_CREDENTIALS")
        shared.synchronize()
    }
    
    /// Get User Credentials
    static func getUserCredentials() -> [String: Any]? {
        if let credentails = shared.dictionary(forKey: "USER_CREDENTIALS") {
            return credentails
        }
        return nil
    }
    
    /// Remove User Credentials
    static func removeUserCredentials() {
        
        let credentails = self.getUserCredentials()
        
        if (credentails != nil) {
            shared.removeObject(forKey: "USER_CREDENTIALS")
        }
    }
    
}
