//
//  Conversation.swift
//  ReadiCloudStorage
//
//  Created by Dushan Saputhanthri on 5/21/22.
//

//import UIKit
//
//public class Conversation: Codable {
// 
//    public var messageId: String?
//    public var messageType: Int?
//    public var message: String?
//    public var senderId: String?
//    public var receiverId: String?
//    public var title: String?
//    public var avatarUrl: String?
//    public var isRevealed: Int?
//    public var createdAt: Double?
// 
//    public init(messageId: String?, messageType: Int?, message: String?, senderId: String?, receiverId: String?, title: String?, avatarUrl: String?, isRevealed: Int?, createdAt: Double?) {
//        self.messageId = messageId
//        self.messageType = messageType
//        self.message = message
//        self.senderId = senderId
//        self.receiverId = receiverId
//        self.title = title
//        self.avatarUrl = avatarUrl
//        self.isRevealed = isRevealed
//        self.createdAt = createdAt
//    }
// 
//    public enum CodingKeys: String, CodingKey {
//        case messageId = "message_id"
//        case messageType = "message_type"
//        case message
//        case senderId = "sender_id"
//        case receiverId = "receiver_id"
//        case title
//        case avatarUrl = "avatar_url"
//        case isRevealed = "is_revealed"
//        case createdAt = "created_at"
//    }
//}
// 
//public enum ConversationType: Int {
//    case personal = 1
//    case anonymous = 2
//    case group = 3
//    case groupAnonymous = 4
//    case unknown
//}
