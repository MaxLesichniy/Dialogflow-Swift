//
//  DetectIntentResponseBody.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 27.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation
import AnyCodable

public struct DetectIntentResponseBody: Codable {
    
    /// The unique identifier of the response. It can be used to locate a response in the training example set or for reporting issues.
    public var responseId: String
    
    /// The selected results of the conversational query or event processing. See alternativeQueryResults for additional potential results.
    public var queryResult: QueryResult
    
    /// Specifies the status of the webhook request.
//TODO:    public var webhookStatus: Status
    
    /// The audio data bytes encoded as specified in the request. Note: The output audio is generated based on the values of default platform text responses found in the queryResult.fulfillment_messages field. If multiple default text responses exist, they will be concatenated when generating audio. If no default platform text responses exist, the generated audio content will be empty.
    /// In some scenarios, multiple output audio fields may be present in the response structure. In these cases, only the top-most-level audio output has content.
    /// A base64-encoded string.
    public var outputAudio: String?
    
    /// The config used by the speech synthesizer to generate the output audio.
    public var outputAudioConfig: OutputAudioConfig?
}

public extension DetectIntentResponseBody {
    
    struct QueryResult: Codable {
        /// The original conversational query text:
        /// If natural language text was provided as input, queryText contains a copy of the input.
        /// If natural language speech audio was provided as input, queryText contains the speech recognition result. If speech recognizer produced multiple alternatives, a particular one is picked.
        /// If automatic spell correction is enabled, queryText will contain the corrected user input.
        public var queryText: String
        
        /// The language that was triggered during intent detection. See Language Support (https://cloud.google.com/dialogflow/docs/reference/language) for a list of the currently supported language codes.
        public var languageCode: String
        
        /// The Speech recognition confidence between 0.0 and 1.0. A higher number indicates an estimated greater likelihood that the recognized words are correct. The default of 0.0 is a sentinel value indicating that confidence was not set.
        /// This field is not guaranteed to be accurate or set. In particular this field isn't set for StreamingDetectIntent since the streaming endpoint has separate confidence estimates per portion of the audio in StreamingRecognitionResult.
        public var speechRecognitionConfidence: Float?
        
        /// The action name from the matched intent.
        public var action: String?
        
        /**
         The collection of extracted parameters.

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
        
        /**
         This field is set to:

         - false if the matched intent has required parameters and not all of the required parameter values have been collected.
         - true if all required parameter values have been collected, or if the matched intent doesn't contain any required parameters.
         */
        public var allRequiredParamsPresent: Bool?
        
        /// The text to be pronounced to the user or shown on the screen. Note: This is a legacy field, fulfillmentMessages should be preferred.
        public var fulfillmentText: String?
        
        /// The collection of rich messages to present to the user.
        public var fulfillmentMessages: [Message]?
        
//        #if !WEBHOOK_MODELS
        /// If the query was fulfilled by a webhook call, this field is set to the value of the source field returned in the webhook response.
        public var webhookSource: String?
        
        /// If the query was fulfilled by a webhook call, this field is set to the value of the payload field returned in the webhook response.
        public var webhookPayload: AnyCodable?
//        #endif
        
        /// The collection of output contexts. If applicable, outputContexts.parameters contains entries with name <parameter name>.original containing the original parameter values before the query.
        public var outputContexts: [Context]?
        
        /// The intent that matched the conversational query. Some, not all fields are filled in this message, including but not limited to: name, displayName, endInteraction and isFallback.
        public var intent: Intent
        
        /// The intent detection confidence. Values range from 0.0 (completely uncertain) to 1.0 (completely certain). This value is for informational purpose only and is only used to help match the best intent within the classification threshold. This value may change for the same end-user expression at any time due to a model retraining or change in implementation. If there are multiple knowledgeAnswers messages, this value is set to the greatest knowledgeAnswers.match_confidence value in the list.
        public var intentDetectionConfidence: Float
        
        /**
         Free-form diagnostic information for the associated detect intent request. The fields of this data can change without notice, so you should not write code that depends on its structure. The data may contain:

         - webhook call latency
         - webhook errors
         */
        public var diagnosticInfo: AnyCodable?
        
        /// The sentiment analysis result, which depends on the sentimentAnalysisRequestConfig specified in the request.
        public var sentimentAnalysisResult: SentimentAnalysisResult?
    }
    
}

public extension DetectIntentResponseBody.QueryResult {
    
    /// The result of sentiment analysis as configured by `sentimentAnalysisRequestConfig`.
    struct SentimentAnalysisResult: Codable {
        /// The sentiment analysis result for queryText.
        public var queryTextSentiment: Sentiment
        
        /// The sentiment, such as positive/negative feeling or association, for a unit of analysis, such as the query text.
        public struct Sentiment: Codable {
            /// Sentiment score between -1.0 (negative sentiment) and 1.0 (positive sentiment).
            public var score: Float
            /// A non-negative number in the [0, +inf) range, which represents the absolute magnitude of sentiment, regardless of score (positive or negative).
            public var magnitude: Float
        }
    }
    
}
