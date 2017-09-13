//
//  ViewController.swift
//  TestDataOne
//
//  Created by hooni.net on 9/8/17.
//  Copyright © 2017 hooni.net. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MediaType {
    case vin
    case movie
    case tv
    case music
    case ebook
    
    func title() -> String {
        switch self {
        case .vin: return "VIN"
        case .movie: return "Movie"
        case .tv: return "TV Show"
        case .music: return "Music"
        case .ebook: return "eBook"
        }
    }
    
    //MARK:- segments
    static var segments: [MediaType] { return [.vin, .movie, .tv, .music, .ebook] }
    
    init(rawValue: Int) {
        if rawValue < MediaType.segments.count {
            self = MediaType.segments[rawValue]
        } else {
            self = .vin
        }
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //requestJsonData()
        
        Vehicle.requestVehicle(term: "55SWF4JB2HU186393") { (error, vehicles) in
            //do test
            dLog(vehicles)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func requestJsonData() {
        let vinCode: String = "55SWF4JB2HU186393"
        
        let urlPath: String = "https://api.dataonesoftware.com/webservices/vindecoder/decode"
        let clientId: String = "15298"
        let authorizationCode: String = "3852d3fb3f51433733d2febd8bc1ceffd3e6878b"
        
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
                        "-identifier": vinCode,
                        "vin": vinCode,
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
        
        //let jsonString = String(data: jsonData!, encoding: .utf8)
        //let decoderQuery = String(data: jsonData!, encoding: .utf8)
        guard let decoderQuery = String(data: jsonData!, encoding: .utf8) else {
            return
        }
        
        let stringParams: String = "client_id=" + clientId + "&authorization_code=" + authorizationCode + "&decoder_query=" + decoderQuery
        
        let url = URL(string: urlPath)
        var jsonRequest = URLRequest(url: url!)
        jsonRequest.httpBody = stringParams.data(using: String.Encoding.utf8, allowLossyConversion: true)
        jsonRequest.httpMethod = "POST"
        //xmlRequest.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        jsonRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(jsonRequest)
            .responseData { (response) in
                //let stringResponse: String = String(data: response.data!, encoding: String.Encoding.utf8) as String!
                //debugPrint(stringResponse)
                
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    print("status code is: \(String(describing: statusCode))")
                    if let string = response.result.value {
                        print("JSON: \(string)")
                    }
                    
                    let stringResponse: String = String(data: response.data!, encoding: String.Encoding.utf8) as String!
                    if let dataFromString = stringResponse.data(using: .utf8, allowLossyConversion: false) {
                        let json = JSON(data: dataFromString)
                        debugPrint(json)
                    }
                    
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
    }
    
    func requestXMLData() {
        let vinCode: String = "55SWF4JB2HU186393"
        
        let urlPath: String = "https://api.dataonesoftware.com/webservices/vindecoder/decode"
        let clientId: String = "15298"
        let authorizationCode: String = "3852d3fb3f51433733d2febd8bc1ceffd3e6878b"
        
        let decoderQuery: String = "<decoder_query>"
        + "<decoder_settings>"
        + "<version>7.0.1</version>"
        + "<display>full</display>"
        + "<styles>on</styles>"
        + "<style_data_packs>"
        + "<basic_data>on</basic_data>"
        + "<specifications>on</specifications>"
        + "<engines>on</engines>"
        + "<transmissions>on</transmissions>"
        + "<installed_equipment>on</installed_equipment>"
        + "<safety_equipment>on</safety_equipment>"
        + "<optional_equipment>on</optional_equipment>"
        + "<colors>on</colors>"
        + "<fuel_efficiency>on</fuel_efficiency>"
        + "<warranties>on</warranties>"
        + "<pricing>on</pricing>"
        + "<awards>on</awards>"
        + "<green_scores>on</green_scores>"
        + "<crash_test>on</crash_test>"
        + "</style_data_packs>"
        + "<common_data>on</common_data>"
        + "<common_data_packs>"
        + "<basic_data>on</basic_data>"
        + "<specifications>on</specifications>"
        + "<engines>on</engines>"
        + "<transmissions>on</transmissions>"
        + "<installed_equipment>on</installed_equipment>"
        + "<safety_equipment>on</safety_equipment>"
        + "<optional_equipment>on</optional_equipment>"
        + "<colors>on</colors>"
        + "<fuel_efficiency>on</fuel_efficiency>"
        + "<warranties>on</warranties>"
        + "<pricing>on</pricing>"
        + "<awards>on</awards>"
        + "<green_scores>on</green_scores>"
        + "<crash_test>on</crash_test>"
        + "</common_data_packs>"
        + "</decoder_settings>"
        + "<query_requests>"
        + "<query_request identifier=\"" + vinCode + "\">"
        + "<vin>" + vinCode + "</vin>"
        + "</query_request>"
        + "</query_requests>"
        + "</decoder_query>"
        
        let stringParams: String = "client_id=" + clientId + "&authorization_code=" + authorizationCode + "&decoder_query=" + decoderQuery
        
        
        let url = URL(string: urlPath)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = stringParams.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        //xmlRequest.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        xmlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(xmlRequest)
            .responseData { (response) in
                let stringResponse: String = String(data: response.data!, encoding: String.Encoding.utf8) as String!
                debugPrint(stringResponse)
        }
    }

    

}

