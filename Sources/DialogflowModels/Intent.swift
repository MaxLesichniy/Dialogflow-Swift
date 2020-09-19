//
//  Intent.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 27.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation

public struct Intent: Codable {
    
    /**
    The unique identifier of this intent. Required for Intents.UpdateIntent and Intents.BatchUpdateIntents methods. Format: `projects/<Project ID>/agent/intents/<Intent ID>`. Optional.
     */
    public var name: String?
    
    /**
    The name of this intent. Required.
     */
    public var displayName: String
    
}
