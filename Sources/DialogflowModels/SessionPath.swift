//
//  SessionPath.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 03.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation

public struct SessionPath {
    public let projectId: String
    public let sessionId: String
    public let userId: String?
    public let environmentId: String?

    public init(projectId: String, sessionId: String, userId: String?, environmentId: String?) {
        self.projectId = projectId
        self.sessionId = sessionId
        self.userId = userId
        self.environmentId = environmentId
    }
    
    public func makePath() -> String {
        return "projects/\(projectId)/agent/environments/\(environmentId ?? "draft")/users/\(userId ?? "-")/sessions/\(sessionId)"
    }
}


