//
//  PushNotificationsAPI.swift
//  Copyright © 2020 RYRA Circuit. All rights reserved.
//

import Foundation


open class PushNotificationsAPI {
    
    open class func sendPushNotification(parameters: [String : Any], completion: @escaping ((_ data: ChatMessageResponse?, _ error: Error?) -> Void)) {
        
        let urlString: String = API.firebaseFCMSendUrl
        
        APIClient.performRequest(urlString: urlString, headerType: .Firebase, parameters: parameters, method: .post) { (status, data, error) in
            completion(data, error)
        }
    }
    
}
