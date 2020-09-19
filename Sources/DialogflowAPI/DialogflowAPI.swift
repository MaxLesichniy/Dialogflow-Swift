//
//  DialogflowAPI.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 03.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation
import Alamofire


public class DialogflowAPI {
    
    var session: Session!
    let basePath = URL(string: "https://dialogflow.googleapis.com/v2/")!
    let serviceAccountJsonFile: URL
    
    public init(serviceAccountJsonFile: URL) {
        self.serviceAccountJsonFile = serviceAccountJsonFile
        resetNetworkSession()
    }
    
    private func resetNetworkSession() {
        let configuretion = URLSessionConfiguration.default
        configuretion.headers.add(name: "Content-Type", value: "application/json")
        
        let interceptor = DialogflowAPIAuthHandler(serviceAccountJsonFile: serviceAccountJsonFile)
        session = Session(configuration: configuretion, interceptor: interceptor)
    }
    
}
