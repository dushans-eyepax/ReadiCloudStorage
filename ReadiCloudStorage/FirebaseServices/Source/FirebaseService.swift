//
//  FirebaseService.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/21/22.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class FirebaseService {
    
    static let shared = FirebaseService()

    private init() {}
    
    static let reference = Database.database().reference()
    
    static let usersReference = reference.child("users")
    
    func configure(isPersistenceEnabled: Bool) {
        FirebaseApp.configure()
        // Uncomment below if use database offline
//        Database.database().isPersistenceEnabled = isPersistenceEnabled
        
        self.signOutOldUser()
        
        self.signIn()
    }
    
    
    private func signOutOldUser() {
        if let _ = UserDefaults.standard.value(forKey: "isNewuser") {
            
        }
        else {
            do {
                UserDefaults.standard.set(true, forKey: "isNewuser")
                try Auth.auth().signOut()
            } catch {
                
            }
        }
    }
    
    func signIn() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Authenticated successfully")
            }
        }
    }
    
}


extension DatabaseReference {
    
    //MARK: Listen for data key and value list changes at a particular location
    func makeKeyAndValueListsRequest<K: Decodable, V: Decodable>(completion: @escaping (K, V) -> Void) {
        self.observe(.value, with: { snapshot in
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
            let keysDict = object.compactMap { $0.key }
            let valuesDict = object.compactMap { $0.value as? [String: Any] }
            do {
                let jsonDataKeys = try JSONSerialization.data(withJSONObject: keysDict, options: [])
                let parsedKeyObjects = try JSONDecoder().decode(K.self, from: jsonDataKeys)
                
                let jsonDataValues = try JSONSerialization.data(withJSONObject: valuesDict, options: [])
                let parsedValueObjects = try JSONDecoder().decode(V.self, from: jsonDataValues)
                
                completion(parsedKeyObjects, parsedValueObjects)
            } catch let error {
                print(error)
            }
        })
    }
    
    
    //MARK: Listen for data list changes at a particular location
    func makeValueListRequest<V: Decodable>(completion: @escaping (V) -> Void) {
        self.observe(.value, with: { snapshot in
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
            let dict = object.compactMap { $0.value as? [String: Any] }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                let parsedObjects = try JSONDecoder().decode(V.self, from: jsonData)
                completion(parsedObjects)
            } catch let error {
                print(error)
            }
        })
    }
    
    
    //MARK: Except the block is immediately canceled after the initial data lists are returned
    func makeSimpleKeyAndValueListsRequest<K: Decodable, V: Decodable>(completion: @escaping (K, V) -> Void) {
        self.observeSingleEvent(of: .value, with: { snapshot in
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
            let keysDict = object.compactMap { $0.key }
            let valuesDict = object.compactMap { $0.value as? [String: Any] }
            do {
                let jsonDataKeys = try JSONSerialization.data(withJSONObject: keysDict, options: [])
                let parsedKeyObjects = try JSONDecoder().decode(K.self, from: jsonDataKeys)
                
                let jsonDataValues = try JSONSerialization.data(withJSONObject: valuesDict, options: [])
                let parsedValueObjects = try JSONDecoder().decode(V.self, from: jsonDataValues)
                
                completion(parsedKeyObjects, parsedValueObjects)
            } catch let error {
                print(error)
            }
        })
    }
    
    
    //MARK: Except the block is immediately canceled after the initial data list is returned
    func makeSimpleValueListRequest<T: Decodable>(completion: @escaping (T) -> Void) {
        self.observeSingleEvent(of: .value, with: { snapshot in
            guard let object = snapshot.children.allObjects as? [DataSnapshot] else { return }
            let dict = object.compactMap { $0.value as? [String: Any] }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                let parsedObjects = try JSONDecoder().decode(T.self, from: jsonData)
                completion(parsedObjects)
            } catch let error {
                print(error)
            }
        })
    }
    
}


extension Collection {
    
    //MARK: Designed for use with Dictionary and Array types
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
}
