//
//  DialogflowAPIAuthHandler.swift
//  DialogflowAPI
//
//  Created by Max Lesichniy on 27.05.2020.
//  Copyright © 2020 OnCreate. All rights reserved.
//

import Foundation
import Alamofire
import SwiftJWT

struct ServiceAccountJson: Codable {
    public let type: String
    public let projectId: String
    public let privateKeyId: String
    public let privateKey: String
    public let clientEmail: String
    public let clientId: String
    public let authURI: URL
    public let tokenURI: URL
    public let authProviderX509CertUrl: String
    public let clientX509CertUrl: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case projectId = "project_id"
        case privateKeyId = "private_key_id"
        case privateKey = "private_key"
        case clientEmail = "client_email"
        case clientId = "client_id"
        case authURI = "auth_uri"
        case tokenURI = "token_uri"
        case authProviderX509CertUrl = "auth_provider_x509_cert_url"
        case clientX509CertUrl = "client_x509_cert_url"
    }
}

struct AuthAccessToken: Codable {
    let accessToken: String
    let scope: String?
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

enum DialogflowAPIAuthHandlerError: Error {
    case invalidServiceAccountJson
}

class DialogflowAPIAuthHandler: RequestInterceptor {
    
    typealias AdapterResult<T> = Result<T, Error>
    private typealias RefreshCompletion = (_ error: Error?) -> Void
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        return Session(configuration: configuration)
    }()
    
    private let lock = NSLock()
    
    var accessToken: AuthAccessToken?
    
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    private var serviceAccountJson: ServiceAccountJson?
    
    
    // MARK: - Initialization
    
    public init(serviceAccountJsonFile: URL) {
        do {
            let data = try Data(contentsOf: serviceAccountJsonFile)
            self.serviceAccountJson = try JSONDecoder().decode(ServiceAccountJson.self, from: data)
        } catch {
            debugPrint(error)
        }
    }
    
    func clearTokens() {
        accessToken = nil
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AdapterResult<URLRequest>) -> Void) {
        var newUrlRequest = urlRequest
        
        if let token = self.accessToken {
            newUrlRequest.headers.add(name: "Authorization", value: "\(token.tokenType) \(token.accessToken)")
        }
        
        completion(.success(newUrlRequest))
    }
    
    // MARK: - RequestRetrier
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock();
        defer {
            lock.unlock()
        }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] error in
                    guard let `self` = self else { return }
                    
                    self.lock.lock();
                    defer {
                        self.lock.unlock()
                    }
                    
                    if let error = error {
                        debugPrint(error)
                        
                        self.requestsToRetry.forEach { $0(.doNotRetryWithError(error)) }
                    } else {
                        self.requestsToRetry.forEach { $0(.retry) }
                    }
                    
                    self.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        guard let serviceAccountJson = self.serviceAccountJson,
            let privateKey = serviceAccountJson.privateKey.data(using: .utf8) else {
                completion(DialogflowAPIAuthHandlerError.invalidServiceAccountJson)
                return
        }
        
        let jwtHeader = Header()
        let jwtClaims = DialogflowClaims(iss: serviceAccountJson.clientEmail,
                                         sub: nil,
                                         aud: serviceAccountJson.tokenURI.absoluteString,
                                         exp: Date().addingTimeInterval(3600), nbf: nil, iat: Date(),
                                         jti: nil,
                                         scope: "https://www.googleapis.com/auth/dialogflow")
        var jwt = JWT(header: jwtHeader, claims: jwtClaims)
        
        let jwtSigner = JWTSigner.rs256(privateKey: privateKey)
        
        do {
            let signedJWT = try jwt.sign(using: jwtSigner)
            
            let parameters: [String: Any] = [
                "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                "assertion": signedJWT
            ]
            
            sessionManager.request(serviceAccountJson.tokenURI, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseDecodable(of: AuthAccessToken.self) { response in
                    self.isRefreshing = false
                    do {
                        self.accessToken = try response.result.get()
                        completion(nil)
                    } catch {
                        completion(error)
                    }
            }
        } catch {
            completion(error)
        }
        
    }
    
}
