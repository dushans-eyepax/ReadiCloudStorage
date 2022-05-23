//
//  Created by Dushan Saputhanthri on 15/6/18.
//  Copyright © 2018 RYRA Circuit. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum ResponseStatus: String {
    case success
    case error
}

enum AppEnvironment {
    case development
    case staging
    case production
}

struct API {
    
    private static let appEnvironment: AppEnvironment = .development
    
    static let firebaseFCMSendUrl = "https://fcm.googleapis.com/fcm/send"
//    static let countriesUrl = "https://restcountries.eu/rest/v2/all"
    
    static var BaseURL: String {
        get {
            switch appEnvironment {
            case .development:
                return ""
            case .staging:
                return ""
            case .production:
                return ""
            }
        }
    }
    
    static var APIKey: String {
        get {
            switch appEnvironment {
            case .development:
                return ""
            case .staging:
                return ""
            case .production:
                return ""
            }
        }
    }
}

enum WebService: String {
    case refreshToken = ""
    case login = "/"
    case register = "//"
    case countries = "///"
}
