import Testing
import Foundation

@testable import CoreAPIClient

struct APIClientTests {

    private static let expectedResponseData = """
    {
        "title": "Recent Uploads tagged paris",
        "link": "https://www.flickr.com/photos/tags/paris/",
        "description": "",
        "modified": "2025-02-21T18:02:23Z",
        "generator": "https://www.flickr.com",
        "items": [
            {
                "title": "Piece of Art",
                "link": "https://www.flickr.com/photos/199921799@N02/54341118456/",
                "media": {"m":"https://live.staticflickr.com/65535/54341118456_e79226d825_m.jpg"},
                "date_taken": "2024-05-22T15:45:50-08:00",
                "description": "mm",
                "published": "2025-02-21T18:02:23Z",
                "author": "nobody",
                "author_id": "199921799@N02",
                "tags": "louvre paris art museum sculture statue"
            }
        ]
    }
    """.data(using: .utf8)!

    let apiClient: APIClient = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let apiClient = APIClient(environment: APIEnvironmentDev(), configuration: configuration)
        return apiClient
    }()

    @Test func testGallery() async throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let expectedItem = try! jsonDecoder.decode(Gallery.self, from: APIClientTests.expectedResponseData)

        let tag = "Paris"
        let urlString = apiClient.environment.baseUrlString + APIClient.GalleryURLPath.fetchGallery(tag).urlPath
        guard let url = URL(string: urlString) else {
            Issue.record("Invalid url string")
            return
        }

        await MockURLProtocol.setHandler { request in
            let nonHTTPResponse = HTTPURLResponse(
                url: url,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
            return (nonHTTPResponse, APIClientTests.expectedResponseData)
        }

        do {
            let gallery = try await apiClient.fetchGallery(for: tag)

            #expect(gallery.title == expectedItem.title)
            #expect(gallery.items.count == expectedItem.items.count)
            #expect(gallery.items[0].title == expectedItem.items[0].title)
            #expect(gallery.items[0].media == expectedItem.items[0].media)
            #expect(gallery.items[0].link.absoluteString == expectedItem.items[0].link.absoluteString)
            #expect(gallery.items[0].dateTaken == expectedItem.items[0].dateTaken)
            #expect(gallery.items[0].published == expectedItem.items[0].published)
            #expect(gallery.items[0].author == expectedItem.items[0].author)
            #expect(gallery.items[0].authorId == expectedItem.items[0].authorId)
            #expect(gallery.items[0].tags == expectedItem.items[0].tags)
        } catch {
            Issue.record("Request failed with error: \(error)")
        }
    }

}
