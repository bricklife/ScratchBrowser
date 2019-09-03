//
//  ScratchLink.swift
//  ScratchLink
//
//  Created by Shinichiro Oba on 2019/08/30.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer
import PerfectWebSockets

typealias uint8 = UInt8
typealias uint16 = UInt16
typealias uint32 = UInt32

public enum InitializationError: Error {
    case server(String)
    case internalError(String)
}

public enum SerializationError: Error {
    case invalid(String)
    case internalError(String)
}

public class ScratchLink {
    
    let sessionManager = SessionManager<BLESession>()
    
    public init() {}
    
    public func startServer() throws {
        guard let certPath = Bundle.main.path(forResource: "scratch-device-manager", ofType: "pem") else {
            throw InitializationError.server("Failed to find certificate resource")
        }
        
        var routes = Routes()
        routes.add(method: .get, uri: "/scratch/ble") { [weak self] (request, response) in
            self?.handleRequest(request: request, response: response)
        }
        
        print("Starting server...")
        try HTTPServer.launch(wait: false, HTTPServer.Server(
            tlsConfig: TLSConfiguration(certPath: certPath),
            name: "device-manager.scratch.mit.edu",
            port: 20110,
            routes: routes
        ))
        print("Server started")
    }
    
    func handleRequest(request: HTTPRequest, response: HTTPResponse) {
        print("request path: \(request.path)")
        do {
            try sessionManager
                .makeSessionHandler(forRequest: request)
                .handleRequest(request: request, response: response)
        } catch {
            response.setBody(string: "Session init failed")
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            response.completed(status: .internalServerError)
        }
    }
}
