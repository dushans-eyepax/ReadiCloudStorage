//
//  Constant.swift
//  Copyright © 2019 RYRA Circuit. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    
    static let iOSAppDownloadLink = "https://apps.apple.com/us/app/idXXXXXXXXXXX"
    
    enum ServerAPIKeys {
        static let googleServices = ""
        static let googleClientid = "439461828423-pq7lpqi1esuk8oj6aa8l2uf5mghcf9td.apps.googleusercontent.com"
        static let firebaseServices = "AAAAo7N5DPw:APA91bGAZgguYmW1JlUTBV936guGyWnqfPSuGwImlIwDhRPpxIX5tRNgjbaPXUQgrHCAuPkqNNcqAnmlej7rNoT3rYqRZdJGVUK-ZRFGQCYwIhdncN3exh8IwVDumpLXZuMtRhf2xZO5"
    }
    
    enum Counts {
        static let passwordCount = 6
        static let nameMinimumCharCount = 2
        static let otpCodeCount = 4
    }
}
