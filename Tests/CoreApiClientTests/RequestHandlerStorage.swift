//
//  RequestHandlerStorage.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 22.02.25.
//

import Foundation

internal actor RequestHandlerStorage {
    typealias RequestComptetion = (HTTPURLResponse, Data?)
    private var requestHandler: ( @Sendable (URLRequest) async throws -> RequestComptetion)?

    func setHandler(_ handler: @Sendable @escaping (URLRequest) async throws -> RequestComptetion) async {
        requestHandler = handler
    }

    func executeHandler(for request: URLRequest) async throws -> RequestComptetion {
        guard let handler = requestHandler else {
            throw MockURLProtocolError.noRequestHandler
        }
        return try await handler(request)
    }
}
