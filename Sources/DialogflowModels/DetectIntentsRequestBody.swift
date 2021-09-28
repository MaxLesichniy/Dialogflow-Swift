//
//  DetectIntentsRequestBody.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 03.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation
import AnyCodable
#if !os(Linux) && canImport(CoreLocation)
import CoreLocation.CLLocation
#endif

public struct DetectIntentsRequestBody: Codable {
    /// The parameters of this query.
    public var queryParams: QueryParameters?
    
    /// Required. The input specification. It can be set to:
    /// 1. an audio config which instructs the speech recognizer how to process the speech audio,
    /// 2. a conversational query in the form of text, or
    /// 3. an event that specifies which intent to trigger.
    public var queryInput: QueryInput
    
    /// Instructs the speech synthesizer how to generate the output audio. If this field is not set and agent-level speech synthesizer is not configured, no output audio is generated.
    public var outputAudioConfig: OutputAudioConfig?
    
    /// mask for `outputAudioConfig` indicating which settings in this request-level config should override speech synthesizer settings defined at agent-level.
    /// If unspecified or empty, outputAudioConfig replaces the agent-level config in its entirety.
    /// A comma-separated list of fully qualified names of fields. Example: "user.displayName,photo".
    public var outputAudioConfigMask: String?
    
    /// The natural language speech audio to be processed. This field should be populated iff queryInput is set to an input audio config. A single request can contain up to 1 minute of speech audio data.
    /// A base64-encoded string.
    public var inputAudio: String?
    
    public init(queryInput: QueryInput) {
        self.queryInput = queryInput
    }
}

public extension DetectIntentsRequestBody {
    
    struct QueryParameters: Codable {
        
        /// The time zone of this conversational query from the time zone database, e.g., America/New_York, Europe/Paris. If not provided, the time zone specified in agent settings is used.
        public var timeZone: String?
        
        #if !os(Linux) && canImport(CoreLocation)
        /// The geo location of this conversational query.
        public var geoLocation: CLLocationCoordinate2D?
        #endif
        
        /// The collection of contexts to be activated before this query is executed.
//        public let contexts: [Context]
     
        /// Specifies whether to delete all contexts in the current session before the new ones are activated.
        public var resetContexts: Bool = false
        
        /// Additional session entity types to replace or extend developer entity types with. The entity synonyms apply to all languages and persist for the session of this query.
//        public var sessionEntityTypes: []
        
        /// This field can be used to pass custom data to your webhook. Arbitrary JSON objects are supported.
        public var payload: AnyCodable?
        
        /// Configures the type of sentiment analysis to perform. If not provided, sentiment analysis is not performed.
        public var sentimentAnalysisRequestConfig: SentimentAnalysisRequestConfig?
        
        public struct SentimentAnalysisRequestConfig: Codable {
            /// Instructs the service to perform sentiment analysis on queryText. If not provided, sentiment analysis is not performed on queryText.
            public var analyzeQueryTextSentiment: Bool
            
            public init(analyzeQueryTextSentiment: Bool) {
                self.analyzeQueryTextSentiment = analyzeQueryTextSentiment
            }
        }
        
        public init(payload: AnyCodable, resetContexts: Bool = false) {
            self.payload = payload
            self.resetContexts = resetContexts
        }
        
        public init(payload: [String: Any], resetContexts: Bool = false) {
            self.init(payload: AnyCodable(payload), resetContexts: resetContexts)
        }
        
    }
    
    enum QueryInput: Codable {
        case audioConfig(InputAudioConfig)
        case text(TextInput)
        case event(EventInput)
        case undefined
        
        private enum CodingKeys: CodingKey {
            case audioConfig
            case text
            case event
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let audioConfig = try container.decodeIfPresent(InputAudioConfig.self, forKey: .audioConfig) {
                self = .audioConfig(audioConfig)
            } else if let text = try container.decodeIfPresent(TextInput.self, forKey: .text) {
                self = .text(text)
            } else if let event = try container.decodeIfPresent(EventInput.self, forKey: .event) {
                self = .event(event)
            } else {
                self = .undefined
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .audioConfig(let inputAudioConfig):
                try container.encode(inputAudioConfig, forKey: .audioConfig)
            case .text(let textInput):
                try container.encode(textInput, forKey: .text)
            case .event(let eventInput):
                try container.encode(eventInput, forKey: .event)
            default:
                return
            }
        }
        
    }
    
}

public extension DetectIntentsRequestBody.QueryInput {
    
    struct InputAudioConfig: Codable {
        
    }
    
    struct TextInput: Codable {
        /// Required. The UTF-8 encoded natural language text to be processed. Text length must not exceed 256 characters.
        var text: String
        /// Required. The language of this conversational query. See language Support for a list of the currently supported language codes. Note that queries in the same session do not necessarily need to specify the same language.
        var languageCode: String

        public init(text: String, languageCode: String) {
            self.text = text
            self.languageCode = languageCode
        }
    }
    
    struct EventInput: Codable {
        /// Required. The unique identifier of the event.
        public var name: String
        
        /**
         The collection of parameters associated with the event.

         Depending on your protocol or client library language, this is a map, associative array, symbol table, dictionary, or JSON object composed of a collection of (MapKey, MapValue) pairs:

         - MapKey type: string
         - MapKey value: parameter name
         - MapValue type:
           - If parameter's entity type is a composite entity: map
           - Else: string or number, depending on parameter value type
         - MapValue value:
           - If parameter's entity type is a composite entity: map from composite entity property names to property values
           - Else: parameter value
         */
        public var parameters: AnyCodable?
        
        /// Required. The language of this query. See language Support (https://cloud.google.com/dialogflow/docs/reference/language) for a list of the currently supported language codes. Note that queries in the same session do not necessarily need to specify the same language.
        public var languageCode: String

        public init(name: String, languageCode: String, parameters: AnyCodable? = nil) {
            self.name = name
            self.parameters = parameters
            self.languageCode = languageCode
        }
    }
    
}
