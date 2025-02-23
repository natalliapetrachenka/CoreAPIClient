// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public final class APIClient {
    public let environment: APIEnvironment
    internal let urlSession: APISession

    public enum HTTPMethod: String {
        case get = "GET"
    }

    public convenience init(environment: APIEnvironment) {
        self.init(environment: environment, configuration: .default)
    }

    internal init(environment: APIEnvironment,
                  configuration: URLSessionConfiguration) {
        self.environment = environment
        self.urlSession = APISession(configuration: configuration)
    }
}
