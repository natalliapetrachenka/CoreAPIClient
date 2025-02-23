//
//  APISession.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 21.02.25.
//

import Foundation

internal final class APISession {
    private let urlSession: URLSession

    public enum HTTPMethod: String {
        case get = "GET"
    }

    public convenience init() {
        self.init(configuration: .default)
    }

    internal init(configuration: URLSessionConfiguration) {
        self.urlSession = URLSession(configuration: configuration)
    }
}

extension APISession {

    func performRequest<T: Decodable & Sendable>(_ urlString: String,
                                                 method: HTTPMethod,
                                                 interceptor: APIRequestInterceptor? = nil) async throws(APIClientError) -> T {
        let urlRequest = try URLRequest(urlString, method: method)
        return try await performRequest(urlRequest, interceptor: interceptor)
    }

    func performRequest<T: Decodable & Sendable>(_ urlRequest: URLRequest,
                                                 interceptor: APIRequestInterceptor? = nil) async throws(APIClientError) -> T {
        guard let interceptor = interceptor else {
            return try await performRequest(urlRequest)
        }
        let adaptedUrlRequest = try interceptor.adapt(urlRequest, for: urlSession)
        return try await performRequest(adaptedUrlRequest)
    }

    func performRequest<T: Decodable & Sendable>(_ urlRequest: URLRequest) async throws(APIClientError) -> T {
        do {
            let (data, response) = try await self.urlSession.data(for: urlRequest)

            let httpURLResponse = response as? HTTPURLResponse
            guard let httpURLResponse = httpURLResponse, (200...299).contains(httpURLResponse.statusCode) else {
                let str = String(data: data, encoding: .utf8)
                throw APIClientError.unexpectedStatusCode(httpURLResponse?.statusCode ?? 0, str)
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            let decodedData = try jsonDecoder.decode(T.self, from: data)
            return decodedData
        } catch let error as DecodingError {
            throw APIClientError.decoding(error)
        } catch {
            throw APIClientError.server(error)
        }
    }
}
