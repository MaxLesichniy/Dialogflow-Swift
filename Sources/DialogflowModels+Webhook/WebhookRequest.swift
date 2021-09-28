//
//  File.swift
//  
//
//  Created by Max Lesichniy on 08.09.2020.
//

import Foundation
import DialogflowModels
import AnyCodable

public struct WebhookRequest: Codable {
    
    public typealias QueryResult = DetectIntentResponseBody.QueryResult
    
    /// The unique identifier of the response. It can be used to locate a response in the training example set or for reporting issues.
    public var responseId: String
    
    /// The selected results of the conversational query or event processing. See alternativeQueryResults for additional potential results.
    public var queryResult: QueryResult
    
    public var session: String
    
    public var originalDetectIntentRequest: OriginalDetectIntentRequest?
}


public extension WebhookRequest {
    
    struct OriginalDetectIntentRequest: Codable {
        
        public var source: String?
        
        public var payload: AnyCodable?

    }
    
}
