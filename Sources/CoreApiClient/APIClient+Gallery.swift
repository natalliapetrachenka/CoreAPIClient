//
//  APIClient+.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 21.02.25.
//

public protocol GalleryAPIClient {
    func fetchGallery(for tag: String) async throws(APIClientError) -> Gallery
}

extension APIClient: GalleryAPIClient {
    internal enum GalleryURLPath {
        case fetchGallery(String)

        var urlPath: String {
            switch self {
                case .fetchGallery(let tag):
                    return "services/feeds/photos_public.gne?format=json&tags=\(tag)&nojsoncallback=1#"
            }
        }
    }

    public func fetchGallery(for tag: String) async throws(APIClientError) -> Gallery {
        let urlString = environment.baseUrlString + GalleryURLPath.fetchGallery(tag).urlPath
        return try await urlSession.performRequest(urlString, method: APISession.HTTPMethod.get)
    }
}
