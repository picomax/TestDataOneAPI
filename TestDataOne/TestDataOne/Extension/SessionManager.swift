//
//  SessionManager.swift
//  TestDataOne
//
//  Created by picomax on 9/12/17.
//  Copyright © 2017 hooni.net. All rights reserved.
//

import Alamofire
import Foundation

extension SessionManager {
    static let shared: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        let manager = SessionManager(configuration: configuration)
        manager.configureURLCache()
        return manager
    }()
    
    fileprivate func configureURLCache() {
        let cacheSizeMemory = 1024 * 1024 * 1024; // 1024 MB
        let cacheSizeDisk = 1024 * 1024 * 1024; // 1024 MB
        let sharedCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "nsurlcache")
        URLCache.shared = sharedCache
    }
}


enum SDRouter: URLRequestConvertible {
    case vin(term: String)
    case movie(term: String)
    case tvshow(term: String)
    case music(term: String)
    case ebook(term: String)
    
    public func asURLRequest() throws -> URLRequest {
        //let vinCode: String = "55SWF4JB2HU186393"
        let clientId: String = "15298"
        let authorizationCode: String = "3852d3fb3f51433733d2febd8bc1ceffd3e6878b"
        
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.dataonesoftware.com"
        urlComponent.path = "/webservices/vindecoder/decode"
        
        let url = urlComponent.url
        var request = URLRequest(url: url!)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .vin(let term):
            let decoderQuery = getDecoderQuery(term: term)
            let stringParams: String = "client_id=" + clientId + "&authorization_code=" + authorizationCode + "&decoder_query=" + decoderQuery
            request.httpBody = stringParams.data(using: String.Encoding.utf8, allowLossyConversion: true)
            request.httpMethod = "POST"
            break
        default:
            break
        }
        
        return request
    }
    
    func getDecoderQuery(term: String) -> String {
        let jsonDictionary: Dictionary = [
            "decoder_query": [
                "decoder_settings": [
                    "version": "7.0.1",
                    "display": "full",
                    "styles": "on",
                    "style_data_packs": [
                        "basic_data": "on",
                        "specifications": "on",
                        "engines": "on",
                        "transmissions": "on",
                        "installed_equipment": "on",
                        "safety_equipment": "on",
                        "optional_equipment": "on",
                        "colors": "on",
                        "fuel_efficiency": "on",
                        "warranties": "on",
                        "pricing": "on",
                        "awards": "on",
                        "green_scores": "on",
                        "crash_test": "on"
                    ],
                    "common_data": "on",
                    "common_data_packs": [
                        "basic_data": "on",
                        "specifications": "on",
                        "engines": "on",
                        "transmissions": "on",
                        "installed_equipment": "on",
                        "safety_equipment": "on",
                        "optional_equipment": "on",
                        "colors": "on",
                        "fuel_efficiency": "on",
                        "warranties": "on",
                        "pricing": "on",
                        "awards": "on",
                        "green_scores": "on",
                        "crash_test": "on"
                    ]
                ],
                "query_requests": [
                    "query_request": [
                        "-identifier": term,
                        "vin": term,
                        "engine": [ "-description": "(Engine Description)" ],
                        "transmission": [ "-description": "(Transmission Description)" ],
                        "interior_color": [
                            
                        ],
                        "exterior_color": [
                            
                        ]
                    ]
                ]
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        guard let decoderQuery = String(data: jsonData!, encoding: .utf8) else {
            return ""
        }
        
        return decoderQuery;
    }
}

/*
//MARK:- iTunes Search
enum SDRouter: URLConvertible {
    case vin(term: String)
    case movie(term: String)
    case tvshow(term: String)
    case music(term: String)
    case ebook(term: String)
 
    func asURL() throws -> URL {
        //let vinCode: String = "55SWF4JB2HU186393"
        //let urlPath: String = "https://api.dataonesoftware.com/webservices/vindecoder/decode"
        let clientId: String = "15298"
        let authorizationCode: String = "3852d3fb3f51433733d2febd8bc1ceffd3e6878b"
        
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.dataonesoftware.com"
        urlComponent.path = "/webservices/vindecoder/decode"
        
        switch self {
        case .vin(let term):
            let decoderQuery = getDecoderQuery(term: term)
            urlComponent.queryItems = [URLQueryItem(name: "client_id", value: clientId),
                                       URLQueryItem(name: "authorization_code", value: authorizationCode),
                                       URLQueryItem(name: "decoder_query", value: decoderQuery)]
        case .movie(let term):
            urlComponent.queryItems = [URLQueryItem(name: "media", value: "movie"),
                                       URLQueryItem(name: "entity", value: "movie"),
                                       URLQueryItem(name: "term", value: term)]
        case .tvshow(let term):
            urlComponent.queryItems = [URLQueryItem(name: "media", value: "tvShow"),
                                       URLQueryItem(name: "entity", value: "tvSeason"),
                                       URLQueryItem(name: "term", value: term)]
        case .music(let term):
            urlComponent.queryItems = [URLQueryItem(name: "media", value: "music"),
                                       URLQueryItem(name: "entity", value: "musicTrack"),
                                       URLQueryItem(name: "term", value: term)]
        case .ebook(let term):
            urlComponent.queryItems = [URLQueryItem(name: "media", value: "ebook"),
                                       URLQueryItem(name: "entity", value: "ebook"),
                                       URLQueryItem(name: "term", value: term)]
        }
        
        return urlComponent.url!
    }
    
    func getDecoderQuery(term: String) -> String {
        let jsonDictionary: Dictionary = [
            "decoder_query": [
                "decoder_settings": [
                    "version": "7.0.1",
                    "display": "full",
                    "styles": "on",
                    "style_data_packs": [
                        "basic_data": "on",
                        "specifications": "on",
                        "engines": "on",
                        "transmissions": "on",
                        "installed_equipment": "on",
                        "safety_equipment": "on",
                        "optional_equipment": "on",
                        "colors": "on",
                        "fuel_efficiency": "on",
                        "warranties": "on",
                        "pricing": "on",
                        "awards": "on",
                        "green_scores": "on",
                        "crash_test": "on"
                    ],
                    "common_data": "on",
                    "common_data_packs": [
                        "basic_data": "on",
                        "specifications": "on",
                        "engines": "on",
                        "transmissions": "on",
                        "installed_equipment": "on",
                        "safety_equipment": "on",
                        "optional_equipment": "on",
                        "colors": "on",
                        "fuel_efficiency": "on",
                        "warranties": "on",
                        "pricing": "on",
                        "awards": "on",
                        "green_scores": "on",
                        "crash_test": "on"
                    ]
                ],
                "query_requests": [
                    "query_request": [
                        "-identifier": term,
                        "vin": term,
                        "engine": [ "-description": "(Engine Description)" ],
                        "transmission": [ "-description": "(Transmission Description)" ],
                        "interior_color": [
                            
                        ],
                        "exterior_color": [
                            
                        ]
                    ]
                ]
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        guard let decoderQuery = String(data: jsonData!, encoding: .utf8) else {
            return ""
        }
        
        return decoderQuery;
    }
}
*/

extension SessionManager {
    @discardableResult
    func requestDataOneAPI(router: SDRouter, callback: @escaping (DataResponse<Any>) -> Void) -> URLSessionTask? {
        //let request = SessionManager.shared.request(router).responseJSON(completionHandler: callback)
        //let request = SessionManager.shared.request(router, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: callback)
        
        
        let request = SessionManager.shared.request(router).responseJSON(completionHandler: callback)
        
        return request.task
    }
}

