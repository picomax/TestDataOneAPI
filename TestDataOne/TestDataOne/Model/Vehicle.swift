//
//  Vehicle.swift
//  TestDataOne
//
//  Created by picomax on 9/12/17.
//  Copyright © 2017 hooni.net. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct DecoderError {
    let errorCode: String
    let errorMessage: String
    
    init(json: JSON) {
        errorCode = json["error_code"].stringValue
        errorMessage = json["error_message"].stringValue
    }
}

struct DecoderMessages {
    let serviceProvider: String
    let decoderVersion: String
    let decoderErrors: [DecoderError]
    
    init(json: JSON) {
        serviceProvider = json["service_provider"].stringValue
        decoderVersion = json["decoder_version"].stringValue
        
        let array = json["decoder_errors"].arrayValue
        var tmpResult: [DecoderError] = []
        for object in array {
            //let m = Vehicle(json: object)
            //result.append(m)
            let m = DecoderError(json: object)
            tmpResult.append(m)
        }
        decoderErrors = tmpResult
    }
}

struct QueryResponses {
    init(json: JSON) {
    }
}

struct Vehicle {
    let decoderMessages: DecoderMessages
    let queryResponses: QueryResponses
    
    init(json: JSON) {
        decoderMessages = DecoderMessages(json: json["decoder_messages"])
        queryResponses = QueryResponses(json: json["query_responses"])
    }
}

extension Vehicle {
    @discardableResult
    //static func requestVehicle(term: String, callback: @escaping (_ error: NSError?, _ vehicles: [Vehicle]?) -> Void) -> URLSessionTask? {
    static func requestVehicle(term: String, callback: @escaping (_ error: NSError?, _ vehicles: Vehicle?) -> Void) -> URLSessionTask? {
        let router = SDRouter.vin(term: term)
        return SessionManager.shared.requestDataOneAPI(router: router, callback: { (response) in
            switch response.result {
            case .failure(let error):
                dLog(error)
                callback(error as NSError, nil)
            case .success(let value):
                let json = JSON(value)
                /*
                //resultCount
                //results
                let array = json["results"].arrayValue
                //let m = Vehicle.init(json: json)
                //let m = (array?.filter({ $0.string != nil }).map({ $0.string! }))!
                var result: [Vehicle] = []
                for object in array {
                    let m = Vehicle(json: object)
                    result.append(m)
                }
                callback(nil, result)
                */
                let result: Vehicle = Vehicle(json: json)
                callback(nil, result)
            }
        })
    }
}


