//
//  API.swift
//  The MUT
//
//  Created by Benjamin Whitis on 6/14/19.
//  Copyright © 2019 Levenick Enterprises LLC. All rights reserved.
//

import Foundation
import Cocoa


public class APIFunctions: NSObject, URLSessionDelegate{

    let dataPrep = dataPreparation()
    var allowUntrustedFlag: Bool!

    public func putData(passedUrl: String, credentials: String, endpoint: String, identifierType: String, identifier: String, allowUntrusted: Bool, xmlToPut: Data) -> String {

        let baseURL = dataPrep.generateURL(baseURL: passedUrl, endpoint: endpoint, identifierType: identifierType, identifier: identifier, jpapi: false, jpapiVersion: "")

        let encodedURL = NSURL(string: "\(baseURL)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://null")! as URL
        NSLog("[INFO  ]: Submitting a PUT to \(encodedURL.absoluteString)")
        allowUntrustedFlag = allowUntrusted
        let myOpQueue = OperationQueue()
        var globalResponse = ""
        // The semaphore is what allows us to force the code to wait for this request to complete
        // Without the semaphore, MUT will queue up a request for every single line of the CSV simultaneously
        let semaphore = DispatchSemaphore(value: 0)
        let request = NSMutableURLRequest(url: encodedURL)
        
        // Determine the request type. If we pass this in with a variable, we could use this function for PUT as well.
        request.httpMethod = "PUT"
        request.httpBody = xmlToPut
        // Set configuration settings for the request, such as headers
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : "Basic \(credentials)", "Content-Type" : "text/xml"]
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: myOpQueue)
        
        // Completion handler. This is what ensures that the response is good/bad
        // and also what handles the semaphore
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 199 && httpResponse.statusCode <= 299 {
                    // Good response from API
                    globalResponse = response?.description ?? "nil"
                    NSLog("[INFO  ]: Successful PUT completed by The MUT.app")
                    NSLog("[INFO  ]: " + response.debugDescription)
                } else {
                    // Bad Response from API
                    globalResponse = response?.description ?? "nil"
                    NSLog("[ERROR ]: Failed PUT by The MUT.app")
                    NSLog("[ERROR ]: " + response.debugDescription)
                    NSLog("[ERROR ]: " + String(decoding: data!, as: UTF8.self))
                }
                //print("EncodedURL: \(passedUrl.absoluteString)")
                // print(String (data: data!, encoding: .utf8)) // Uncomment for debugging
                semaphore.signal() // Signal completion to the semaphore
            }
            
            if error != nil {
                let errorString = "[FATAL ]: " + error!.localizedDescription
                globalResponse = errorString
                NSLog("[FATAL ]: " + error!.localizedDescription)
                //print("EncodedURL in error: \(passedUrl.absoluteString)")
                semaphore.signal() // Signal completion to the semaphore
                
            }
        })
        task.resume() // Kick off the actual GET here
        semaphore.wait() // Wait for the semaphore before moving on to the return value
        return globalResponse
    }

    public func enforceName(passedUrl: String, credentials: String, allowUntrusted: Bool, xmlToPost: Data) -> String {

        let baseURL = dataPrep.generateURL(baseURL: passedUrl, endpoint: "mobiledevicecommands", identifierType: "command", identifier: "DeviceName", jpapi: false, jpapiVersion: "")

        let encodedURL = NSURL(string: "\(baseURL)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://null")! as URL
        NSLog("[INFO  ]: Submitting a POST to \(encodedURL.absoluteString)")
        allowUntrustedFlag = allowUntrusted
        let myOpQueue = OperationQueue()
        var globalResponse = ""
        // The semaphore is what allows us to force the code to wait for this request to complete
        // Without the semaphore, MUT will queue up a request for every single line of the CSV simultaneously
        let semaphore = DispatchSemaphore(value: 0)
        let request = NSMutableURLRequest(url: encodedURL)

        // Determine the request type. If we pass this in with a variable, we could use this function for PUT as well.
        request.httpMethod = "POST"
        request.httpBody = xmlToPost
        // Set configuration settings for the request, such as headers
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : "Basic \(credentials)", "Content-Type" : "text/xml"]
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: myOpQueue)

        // Completion handler. This is what ensures that the response is good/bad
        // and also what handles the semaphore
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 199 && httpResponse.statusCode <= 299 {
                    // Good response from API
                    globalResponse = response?.description ?? "nil"
                    NSLog("[INFO  ]: Successful POST completed by The MUT.app")
                    NSLog("[INFO  ]: " + response.debugDescription)
                } else {
                    // Bad Response from API
                    globalResponse = response?.description ?? "nil"
                    NSLog("[ERROR ]: Failed POST by The MUT.app")
                    NSLog("[ERROR ]: " + response.debugDescription)
                    NSLog("[ERROR ]: " + String(decoding: data!, as: UTF8.self))
                }
                //print("EncodedURL: \(passedUrl.absoluteString)")
                // print(String (data: data!, encoding: .utf8)) // Uncomment for debugging
                semaphore.signal() // Signal completion to the semaphore
            }

            if error != nil {
                let errorString = "[FATAL ]: " + error!.localizedDescription
                globalResponse = errorString
                NSLog("[FATAL ]: " + error!.localizedDescription)
                //print("EncodedURL in error: \(passedUrl.absoluteString)")
                semaphore.signal() // Signal completion to the semaphore

            }
        })
        task.resume() // Kick off the actual GET here
        semaphore.wait() // Wait for the semaphore before moving on to the return value
        return globalResponse
    }


    public func getPrestageScope(passedUrl: URL, token: String, endpoint: String, allowUntrusted: Bool) -> Data {

        NSLog("[INFO  ]: Getting current prestage scope from \(passedUrl.absoluteString)")
        allowUntrustedFlag = allowUntrusted
        let myOpQueue = OperationQueue()
        var globalResponse = "nil".data(using: String.Encoding.utf8, allowLossyConversion: false)!        // The semaphore is what allows us to force the code to wait for this request to complete
        // Without the semaphore, MUT will queue up a request for every single line of the CSV simultaneously
        let semaphore = DispatchSemaphore(value: 0)
        let request = NSMutableURLRequest(url: passedUrl)

        // Determine the request type. If we pass this in with a variable, we could use this function for PUT as well.
        request.httpMethod = "GET"
        // Set configuration settings for the request, such as headers
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : "Bearer \(token)", "Accept" : "application/json"]
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: myOpQueue)

        // Completion handler. This is what ensures that the response is good/bad
        // and also what handles the semaphore
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 199 && httpResponse.statusCode <= 299 {
                    // Good response from API
                    globalResponse = data!
                    NSLog("[INFO  ]: Successful GET completed by The MUT.app")
                    NSLog("[INFO  ]: " + response.debugDescription)
                } else {
                    // Bad Response from API
                    globalResponse = data!
                    NSLog("[ERROR ]: Failed GET by The MUT.app")
                    NSLog("[ERROR ]: " + response.debugDescription)
                    NSLog("[ERROR ]: " + String(decoding: data!, as: UTF8.self))
                }
                //print("EncodedURL: \(passedUrl.absoluteString)")
                // print(String (data: data!, encoding: .utf8)) // Uncomment for debugging
                semaphore.signal() // Signal completion to the semaphore
            }

            if error != nil {
                let errorString = "[FATAL ]: " + error!.localizedDescription
                globalResponse = data!
                NSLog("[FATAL ]: " + error!.localizedDescription)
                //print("EncodedURL in error: \(passedUrl.absoluteString)")
                semaphore.signal() // Signal completion to the semaphore

            }
        })
        task.resume() // Kick off the actual GET here
        semaphore.wait() // Wait for the semaphore before moving on to the return value
        return globalResponse
    }
    
    public func updatePrestage(passedUrl: String, endpoint: String, prestageID: String, jpapiVersion: String, token: String, jsonToSubmit: Data, httpMethod: String, allowUntrusted: Bool) -> Data {
        let baseURL = dataPrep.generatePrestageURL(baseURL: passedUrl, endpoint: endpoint, prestageID: prestageID, jpapiVersion: jpapiVersion)
        
        let encodedURL = NSURL(string: "\(baseURL)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://null")! as URL
        
        NSLog("[INFO  ]: Updating the current prestage scope at \(encodedURL.absoluteString)")
        allowUntrustedFlag = allowUntrusted
        let myOpQueue = OperationQueue()
        var globalResponse = "nil".data(using: String.Encoding.utf8, allowLossyConversion: false)!        // The semaphore is what allows us to force the code to wait for this request to complete
        // Without the semaphore, MUT will queue up a request for every single line of the CSV simultaneously
        let semaphore = DispatchSemaphore(value: 0)
        let request = NSMutableURLRequest(url: encodedURL)
        
        // Determine the request type. If we pass this in with a variable, we could use this function for PUT as well.
        request.httpMethod = httpMethod
        request.httpBody = jsonToSubmit
        // Set configuration settings for the request, such as headers
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : "Bearer \(token)", "Content-type" : "application/json"]
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: myOpQueue)
        
        // Completion handler. This is what ensures that the response is good/bad
        // and also what handles the semaphore
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 199 && httpResponse.statusCode <= 299 {
                    // Good response from API
                    globalResponse = data!
                    NSLog("[INFO  ]: Successful submission completed by The MUT.app")
                    NSLog("[INFO  ]: " + response.debugDescription)
                } else {
                    // Bad Response from API
                    globalResponse = data!
                    NSLog("[ERROR ]: Failed submission by The MUT.app")
                    NSLog("[ERROR ]: " + response.debugDescription)
                    NSLog("[ERROR ]: " + String(decoding: data!, as: UTF8.self))
                }
                //print("EncodedURL: \(passedUrl.absoluteString)")
                // print(String (data: data!, encoding: .utf8)) // Uncomment for debugging
                semaphore.signal() // Signal completion to the semaphore
            }
            
            if error != nil {
                let errorString = "[FATAL ]: " + error!.localizedDescription
                globalResponse = data!
                NSLog("[FATAL ]: " + error!.localizedDescription)
                //print("EncodedURL in error: \(passedUrl.absoluteString)")
                semaphore.signal() // Signal completion to the semaphore
                
            }
        })
        task.resume() // Kick off the actual GET here
        semaphore.wait() // Wait for the semaphore before moving on to the return value
        return globalResponse
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping(  URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if allowUntrustedFlag {
            NSLog("[WARN  ]: The user has selected to allow untrusted SSL. MUT will not be performing SSL verification. This is potentially unsafe.")
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            // NSLog("[INFO  ]: MUT is using default SSL handling.") // Commenting this to not clutter logs of default SSL handing users
            completionHandler(.performDefaultHandling, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
    
}
