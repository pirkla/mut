//
//  DataManipulation.swift
//  The MUT v5
//
//  Created by Michael Levenick on 5/24/19.
//  Copyright © 2019 Michael Levenick. All rights reserved.
//

import Foundation

public class dataManipulation {
    
    // ******************************************
    // Functions to create URLs can be found here
    // ******************************************
    
    public func generateURL(baseURL: String, endpoint: String, jpapi: Bool, jpapiVersion: String) -> URL {
        var instancedURL = baseURL
        if !baseURL.contains(".") {
            instancedURL = "https://" + baseURL + ".jamfcloud.com/"
        }
        var versionEndpoint = ""
        var encodedURL = NSURL(string: "https://null".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)! as URL
        if jpapi {
            //JPAPI URLS
            if jpapiVersion != "nil" {
                versionEndpoint = "\(jpapiVersion)/"
            }
            let concatURL = instancedURL + "/uapi" + versionEndpoint + endpoint
            let cleanURL = concatURL.replacingOccurrences(of: "//uapi", with: "/uapi")
            print(cleanURL)
            encodedURL = NSURL(string: "\(cleanURL)")! as URL
        } else {
            // CAPI URLS
            let concatURL = instancedURL + "/JSSResource" + endpoint
            let cleanURL = concatURL.replacingOccurrences(of: "//JSSResource", with: "/JSSResource")
            print(cleanURL)
            encodedURL = NSURL(string: "\(cleanURL)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)! as URL
        }
        return encodedURL
    }
    
    // ******************************************
    // Functions to encode/decode data can be found here
    // ******************************************
    
    public func base64Credentials(user: String, password: String) -> String {
        // Concatenate the credentials and base64 encode the resulting string
        let concatCredentials = "\(user):\(password)"
        let utf8Credentials = concatCredentials.data(using: String.Encoding.utf8)
        let base64Credentials = utf8Credentials?.base64EncodedString() ?? "nil"
        print(base64Credentials)
        return base64Credentials
    }
    
}