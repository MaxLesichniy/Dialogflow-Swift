//
//  Context.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 27.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation
import AnyCodable

public struct Context: Codable {
    /**
     Required. The unique identifier of the context. Format: projects/<Project ID>/agent/sessions/<Session ID>/contexts/<Context ID>, or projects/<Project ID>/agent/environments/<Environment ID>/users/<User ID>/sessions/<Session ID>/contexts/<Context ID>.

     The Context ID is always converted to lowercase, may only contain characters in a-zA-Z0-9_-% and may be at most 250 bytes long.

     If Environment ID is not specified, we assume default 'draft' environment. If User ID is not specified, we assume default '-' user.

     The following context names are reserved for internal use by Dialogflow. You should not use these contexts or create contexts with these names:

     - __system_counters__
     - *_id_dialog_context
     - *_dialog_params_size
     */
    public var name: String
    
    /// Optional. The number of conversational query requests after which the context expires. The default is 0. If set to 0, the context expires immediately. Contexts expire automatically after 20 minutes if there are no matching queries.
    public var lifespanCount: Int?
    
    /**
     Optional. The collection of parameters associated with this context.

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
    
}
