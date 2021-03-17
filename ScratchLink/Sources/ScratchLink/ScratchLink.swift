//
//  ScratchLink.swift
//  ScratchLink
//
//  Created by Shinichiro Oba on 2019/08/30.
//

import Foundation
import PerfectCrypto
import PerfectHTTP
import PerfectHTTPServer
import PerfectWebSockets

typealias uint8 = UInt8
typealias uint16 = UInt16
typealias uint32 = UInt32

let SDMPort: Int = 20110

enum SDMRoute: String {
    case bluetoothLowEnergy = "/scratch/ble"
    case bluetooth = "/scratch/bt"
}

struct EncodingParams {
    static let key: [UInt8] = [
        0xD8, 0x97, 0xEB, 0x08, 0xE0, 0xE9, 0xDE, 0x8F, 0x0B, 0x77, 0xAD, 0x42, 0x35, 0x02, 0xAF, 0xA5,
        0x13, 0x72, 0xF8, 0xDA, 0xB0, 0xCB, 0xBE, 0x65, 0x0C, 0x1A, 0x1C, 0xBD, 0x5B, 0x10, 0x90, 0xD9
    ]
    static let iv: [UInt8] = [
        0xB5, 0xE4, 0x1D, 0xCC, 0x5B, 0x4D, 0x6F, 0xCD, 0x1C, 0x1E, 0x02, 0x84, 0x30, 0xB9, 0x21, 0xE6
    ]
}

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
        guard let certificate = getWssCertificate() else {
            throw InitializationError.server("Failed to load certificate resource")
        }
        
        var routes = Routes()
        routes.add(method: .get, uri: "/scratch/ble") { [weak self] (request, response) in
            self?.handleRequest(request: request, response: response)
        }
        
        print("Starting server...")
        try HTTPServer.launch(wait: false, HTTPServer.Server(
            tlsConfig: TLSConfiguration(cert: certificate),
            name: "device-manager.scratch.mit.edu",
            port: SDMPort,
            routes: routes
        ))
        print("Server started")
    }
    
    
    func getFileBytes(path: String) -> [UInt8]? {
        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }
        var bytes = [UInt8](repeating: 0, count: data.length)
        data.getBytes(&bytes, length: data.length)
        return bytes
    }
    
    func getWssCertificate() -> String? {
        guard let encryptedCertPath = Bundle.main.path(forResource: "scratch-device-manager", ofType: "pem.enc") else {
            // This probably means the file is missing from the bundle
            return nil
        }
        guard let encryptedBytes = getFileBytes(path: encryptedCertPath) else {
            return nil
        }
        
        guard let decryptedBytes = encryptedBytes
                .decrypt(Cipher.aes_256_cbc, key: EncodingParams.key, iv: EncodingParams.iv) else {
            // This probably means a key or IV problem
            return nil
        }
        
        guard let decryptedString = String(bytes: decryptedBytes, encoding: .utf8) else {
            return nil
        }
        return decryptedString
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
