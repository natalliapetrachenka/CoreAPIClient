//
//  String+Extensions.swift
//  iAppAPIClient
//
//  Created by Natallia Petrachenka on 21.02.25.
//

import Foundation

extension String {

    internal func apiClientUrl() throws(APIClientError) -> URL {
        guard let url = URL(string: self) else {
            throw APIClientError.invalidUrl
        }
        return url
    }
}
