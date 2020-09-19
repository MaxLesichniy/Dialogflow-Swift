//
//  File.swift
//  
//
//  Created by Max Lesichniy on 08.09.2020.
//

import Foundation
import DialogflowModels
import AnyCodable

public struct WebhookResponse: Codable {
    
    public typealias EventInput = DetectIntentsRequestBody.QueryInput.EventInput
    
    public var fulfillmentMessages: [Message]?
    public var outputContexts: [Context]?
    public var followupEventInput: EventInput?
//    public var sessionEntityTypes
    
    public init() {
        self.fulfillmentMessages = []
    }
    
    public init(fulfillmentMessages: [Message]? = nil, outputContexts: [Context]? = nil) {
        self.fulfillmentMessages = fulfillmentMessages
        self.outputContexts = outputContexts
    }

    public init(text: String, outputContexts: [Context]? = nil) {
        self.init(texts: [text])
    }
    
    public init(texts: [String], outputContexts: [Context]? = nil) {
        self.init(fulfillmentMessages: [Message(text: Message.Text(text: texts))], outputContexts: outputContexts)
    }
    
}

public extension WebhookResponse {

    mutating func appendMessage(_ message: Message) -> Self {
        fulfillmentMessages?.append(message)
        return self
    }
    
    mutating func appendPayloadMessage(_ payload: AnyCodable) -> Self {
        return appendMessage(Message(payload: payload))
    }
    
    mutating func appendPayloadMessage<T: Encodable>(_ payload: T) -> Self {
        return appendMessage(Message(payload: AnyCodable(payload)))
    }
    
    mutating func appendTextMessage(_ text: Message.Text) -> Self {
        return appendMessage(Message(text: text))
    }
    
    mutating func appendImageMessage(_ image: Message.Image) -> Self {
        return appendMessage(Message(image: image))
    }
    
}
