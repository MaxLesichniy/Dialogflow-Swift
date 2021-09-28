//
//  File.swift
//  
//
//  Created by Max Lesichniy on 22.09.2020.
//

import Foundation

/// A session represents a conversation between a Dialogflow agent and an end-user. You can create special entities, called session entities, during a session. Session entities can extend or replace custom entity types and only exist during the session that they were created for. All session data, including session entities, is stored by Dialogflow for 20 minutes.
public struct SessionEntityType: Codable {
    
    /**
     Required. The unique identifier of this session entity type. Format: projects/<Project ID>/agent/sessions/<Session ID>/entityTypes/<Entity Type Display Name>, or projects/<Project ID>/agent/environments/<Environment ID>/users/<User ID>/sessions/<Session ID>/entityTypes/<Entity Type Display Name>. If Environment ID is not specified, we assume default 'draft' environment. If User ID is not specified, we assume default '-' user.

     <Entity Type Display Name> must be the display name of an existing entity type in the same agent that will be overridden or supplemented.
     */
    public let name: String
    
    /// Indicates whether the additional data should override or supplement the custom entity type definition.
    public let entityOverrideMode: OverrideMode
    
    /// The collection of entities associated with this session entity type.
    public let entities: [Entity]

    public init(name: String, entityOverrideMode: OverrideMode, entities: [Entity]) {
        self.name = name
        self.entityOverrideMode = entityOverrideMode
        self.entities = entities
    }
    
}

public extension SessionEntityType {
    
    /// The types of modifications for a session entity type.
    enum OverrideMode: String, Codable {
        /// Not specified. This value should be never used.
        case unspecified = "ENTITY_OVERRIDE_MODE_UNSPECIFIED"
        /// The collection of session entities overrides the collection of entities in the corresponding custom entity type.
        case override = "ENTITY_OVERRIDE_MODE_OVERRIDE"
        /**
         The collection of session entities extends the collection of entities in the corresponding custom entity type.
         
         Note: Even in this override mode calls to entityTypes.list, entityTypes.get, entityTypes.create and entityTypes.patch only return the additional entities added in this session entity type. If you want to get the supplemented list, please call EntityTypes.GetEntityType on the custom entity type and merge.
         */
        case supplement = "ENTITY_OVERRIDE_MODE_SUPPLEMENT"
    }
    
}

