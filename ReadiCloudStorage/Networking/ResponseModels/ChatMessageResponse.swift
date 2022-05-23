//
//  ChatMessageResponse.swift
//  Copyright © 2020 RYRA Circuit. All rights reserved.
//

import Foundation

public struct ChatMessageResponse: Codable {
    
    public var failure: Int?
    public var results: [ChatMessageResult]?
    public var canonicalIds: Int?
    public var success: Int?
    public var multicastId: Int?

    public init(failure: Int?, results: [ChatMessageResult]?, canonicalIds: Int?, success: Int?, multicastId: Int?) {
        self.failure = failure
        self.results = results
        self.canonicalIds = canonicalIds
        self.success = success
        self.multicastId = multicastId
    }

    public enum CodingKeys: String, CodingKey {
        case failure
        case results
        case canonicalIds = "canonical_ids"
        case success
        case multicastId = "multicast_id"
    }
    
}


public struct ChatMessageResult: Codable {
    
    public var messageId: String?

    public init(messageId: String?) {
        self.messageId = messageId
    }

    public enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
    }
    
}
