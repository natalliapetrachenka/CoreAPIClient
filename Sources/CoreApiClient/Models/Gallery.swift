//
//  Gallery.swift
//  CoreAPIClient
//
//  Created by Natallia Petrachenka on 22.02.25.
//

import Foundation

public struct Gallery: Codable, Sendable {
    public let title: String
    public let items: [GalleryItem]
}
