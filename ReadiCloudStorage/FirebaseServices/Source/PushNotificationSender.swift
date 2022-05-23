//
//  PushNotificationSender.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/21/22.
//

import UIKit

class PushNotificationSender {
    
    // With Alamofire
    func sendPushNotificationWithFirebase(to token: String?, notificationData: [String: Any], customData: [String: Any], completion: @escaping CompletionHandler) {
        
        guard let _token = token else {
            completion(false, 404, "Could not find device token to send push notification")
            return
        }

        let urlString = API.firebaseFCMSendUrl

        let params: [String : Any] = [
            "to": _token,
            "notification": notificationData,
            "data": customData
        ]

        URLDataRequest(url: urlString, header: .Firebase, param: params, method: .post).requestData { (result) in
            switch result {
            case .Success(let data):
                completion(true, 200, "")

            case .Failure(let error):
                completion(false, 406, error.localizedDescription)
            }
        }
    }
    
    
    // With URL request
    func sendPushNotification(to token: String?, notificationData: [String: Any], customData: [String: Any], completion: @escaping CompletionHandler) {
        
        guard let _token = token else {
            completion(false, 404, "Could not find device token to send push notification")
            return
        }
        
        let urlString = API.firebaseFCMSendUrl
        
        let url = NSURL(string: urlString)!
        
        let params: [String : Any] = [
            "to" : _token,
            "notification" : notificationData,
            "data" : customData
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
        
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.setValue("key=\(Constant.ServerAPIKeys.firebaseServices)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
}
