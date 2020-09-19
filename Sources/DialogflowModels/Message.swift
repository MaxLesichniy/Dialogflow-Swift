//
//  Message.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 27.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation
import AnyCodable

/// A rich response message. Corresponds to the intent Response field in the Dialogflow console. For more information, see Rich response messages.
public struct Message: Codable {
    public typealias Platform = String
    
    public var platform: Platform?
    
    /// Union field message can be only one of the following:
    
    /// A custom platform-specific response.
    public private(set) var payload: AnyCodable?
    public private(set) var text: Text?
    public private(set) var image: Image?
    public private(set) var quickReplies: QuickReplies?
    public private(set) var card: Card?
    /// The voice and text-only responses for Actions on Google.
    public private(set) var simpleResponses: SimpleResponses?

    public init(payload: AnyCodable, platform: Platform? = nil) {
        self.platform = platform
        self.payload = payload
    }
    
    public init(text: Text, platform: Platform? = nil) {
        self.platform = platform
        self.text = text
    }
    
    public init(text: String, platform: Platform? = nil) {
        self.init(text: Text(text: [text]), platform: platform)
    }
    
    public init(image: Image, platform: Platform? = nil) {
        self.platform = platform
        self.image = image
    }
    
    public init(imageUri: URL, accessibilityText: String? = nil,  platform: Platform? = nil) {
        self.init(image: Image(imageUri: imageUri, accessibilityText: accessibilityText), platform: platform)
    }
    
    public init(quickReplies: QuickReplies, platform: Platform? = nil) {
        self.platform = platform
        self.quickReplies = quickReplies
    }
    
    public init(card: Card, platform: Platform? = nil) {
        self.platform = platform
        self.card = card
    }
    
    public init(simpleResponses: SimpleResponses, platform: Platform? = nil) {
        self.platform = platform
        self.simpleResponses = simpleResponses
    }
}

public extension Message {
    
    /// The text response message.
    struct Text: Codable {
        /// Optional. The collection of the agent's responses.
        public var text: [String]?

        public init(text: [String]) {
            self.text = text
        }
    }
    
    /// The image response message.
    struct Image: Codable {
        /// Optional. The public URI to an image file.
        public var imageUri: URL?
        /// Optional. A text description of the image to be used for accessibility, e.g., screen readers.
        public var accessibilityText: String?

        public init(imageUri: URL, accessibilityText: String?) {
            self.imageUri = imageUri
            self.accessibilityText = accessibilityText
        }
    }
    
    /// The quick replies response message.
    struct QuickReplies: Codable {
        /// Optional. The title of the collection of quick replies.
        public var title: String?
        /// Optional. The collection of quick replies.
        public var quickReplies: [String]?

        public init(title: String, quickReplies: [String]?) {
            self.title = title
            self.quickReplies = quickReplies
        }
    }
    
    /// The card response message.
    struct Card: Codable {
        /// Optional. The title of the card.
        public var title: String?
        /// Optional. The subtitle of the card.
        public var subtitle: String?
        /// Optional. The public URI to an image file for the card.
        public var imageUri: URL?
        /// Optional. The collection of card buttons.
        public var buttons: [Button]?
        

        /// Contains information about a button.
        public struct Button: Codable {
            /// Optional. The text to show on the button.
            public var text: String?
            /// Optional. The text to send back to the Dialogflow API or a URI to open.
            public var postback: String?

            public init(text: String, postback: String) {
                self.text = text
                self.postback = postback
            }
        }
        
        public init(title: String, subtitle: String?, imageUri: URL?, buttons: [Button]?) {
            self.title = title
            self.subtitle = subtitle
            self.imageUri = imageUri
            self.buttons = buttons
        }
    }
    
    /// The collection of simple response candidates. This message in QueryResult.fulfillment_messages and WebhookResponse.fulfillment_messages should contain only one SimpleResponse.
    struct SimpleResponses: Codable {
        /// Required. The list of simple responses.
        public var simpleResponses: [SimpleResponse]
        
        public struct SimpleResponse: Codable {
            /// One of textToSpeech or ssml must be provided. The plain text of the speech output. Mutually exclusive with ssml.
            public var textToSpeech: String?
            /// One of textToSpeech or ssml must be provided. Structured spoken response to the user in the SSML format. Mutually exclusive with textToSpeech.
            public var ssml: String?
            /// Optional. The text to display.
            public var displayText: String?
        }
    }
    
}
