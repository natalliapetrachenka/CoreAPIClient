//
//  GalleryItem.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 22.02.25.
//

import Foundation

public struct GalleryItem: Codable, Sendable {
    public let title: String
    public let link: URL
    public let media: URL
    public let dateTaken: Date
    public let published: Date
    public let author: String
    public let authorId: String
    public let tags: String

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case media
        case dateTaken = "date_taken"
        case published
        case author
        case authorId = "author_id"
        case tags
    }

    private enum MediaKeys: String, CodingKey {
        case m
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        link = try container.decode(URL.self, forKey: .link)
        dateTaken = try container.decode(Date.self, forKey: .dateTaken)
        published = try container.decode(Date.self, forKey: .published)
        author = try container.decode(String.self, forKey: .author)
        authorId = try container.decode(String.self, forKey: .authorId)
        tags = try container.decode(String.self, forKey: .tags)

        let mediaContainer = try container.nestedContainer(keyedBy: MediaKeys.self, forKey: .media)
        media = try mediaContainer.decode(URL.self, forKey: .m)
    }
}
