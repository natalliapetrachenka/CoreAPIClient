//
//  Untitled.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 21.02.25.
//

import Foundation

extension URLRequest {

    internal init(_ urlString: String, method: APISession.HTTPMethod) throws(APIClientError) {
        let url = try urlString.apiClientUrl()
        self.init(url, method: method)
    }

    internal init(_ url: URL, method: APISession.HTTPMethod) {
        self.init(url: url)
        self.httpMethod = method.rawValue
    }
}
