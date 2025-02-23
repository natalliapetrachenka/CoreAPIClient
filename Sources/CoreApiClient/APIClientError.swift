//
//  APIClientError.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 21.02.25.
//

import Foundation

public enum APIClientError: LocalizedError {
    case server(Error)
    case decoding(Error)
    case unexpectedStatusCode(Int, String?)
    case invalidUrl
    case urlAdaptingFailed(Error)
}

extension APIClientError {
    public var errorDescription: String? {
        switch self {
        case .server(let error):
            return "Internal server error: \(error)"
        case .decoding(let error):
            return "Decoding error: \(error)"
        case .unexpectedStatusCode(let code, let text):
            return "Unexpected Status Code: \(code), data: \(text ?? "no data") "
        case .invalidUrl:
            return "Invalid Url"
        case .urlAdaptingFailed(let error):
            return "Url Adapting Failed error \(error)"
        }
    }
}
