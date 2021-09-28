//
//  Entity.swift
//  
//
//  Created by Max Lesichniy on 22.09.2020.
//

import Foundation

public struct Entity: Codable {
    
    /**
     The primary value associated with this entity entry. For example, if the entity type is vegetable, the value could be scallions.

     - For KIND_MAP entity types:
     A reference value to be used in place of synonyms.
     
     - For KIND_LIST entity types:
     A string that can contain references to other entity types (with or without aliases).
     */
    let value: String
    
    /**
     A collection of value synonyms. For example, if the entity type is vegetable, and value is scallions, a synonym could be green onions.

     - For KIND_LIST entity types:
     This collection must contain exactly one synonym equal to value.
     */
    let synonyms: [String]

    public init(value: String, synonyms: [String]) {
        self.value = value
        self.synonyms = synonyms
    }
    
}
