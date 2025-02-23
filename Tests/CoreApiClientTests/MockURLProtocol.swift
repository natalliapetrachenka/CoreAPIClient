//
//  MockURLProtocol.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 22.02.25.
//

import Foundation

internal final class MockURLProtocol: URLProtocol, @unchecked Sendable {

    private static let requestHandlerStorage = RequestHandlerStorage()

    static func setHandler(_ handler: @Sendable @escaping (URLRequest) async throws -> RequestHandlerStorage.RequestComptetion) async {
        await requestHandlerStorage.setHandler { request in
            try await handler(request)
        }
    }

    func executeHandler(for request: URLRequest) async throws -> RequestHandlerStorage.RequestComptetion {
        return try await Self.requestHandlerStorage.executeHandler(for: request)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        Task {
            do {
                let (response, data) = try await self.executeHandler(for: request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                if let data = data {
                    client?.urlProtocol(self, didLoad: data)
                }
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }

    }

    override func stopLoading() {}
}


internal enum MockURLProtocolError: Error {
    case noRequestHandler
    case invalidURL
}
