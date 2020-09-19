//
//  DialogflowAPI+DetectIntents.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 03.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation
import Alamofire

public extension DialogflowAPI {
    
    func detectIntents(sessionPath: SessionPath, requestBody: DetectIntentsRequestBody, completion: @escaping (AFDataResponse<DetectIntentResponseBody>) -> Void) {
        let url = basePath.appendingPathComponent(sessionPath.makePath() + ":detectIntent")
        session.request(url, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(completionHandler: completion)
    }
    
    
}
