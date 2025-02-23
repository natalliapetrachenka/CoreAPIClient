//
//  APIRequestAdapter.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 21.02.25.
//

import Foundation

public protocol APIRequestAdapter {
    func adapt(_ urlRequest: URLRequest, for session: URLSession) throws(APIClientError) -> URLRequest
}

extension APIRequestAdapter {
    func adapt(_ urlRequest: URLRequest, for session: URLSession) throws(APIClientError) -> URLRequest {
        return urlRequest
    }
}
