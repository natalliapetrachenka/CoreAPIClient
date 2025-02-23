//
//  APIEnvironmentDev.swift
//  iAppAPIClient
//
//  Created by Natallia Petrachenka on 21.02.25.
//

public struct APIEnvironmentDev: APIEnvironment {
    public var baseUrlString: String {
        return "https://api.flickr.com/"
    }
    public init() {}
}
