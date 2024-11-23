//
//  Article.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//

import Foundation

struct Article: Codable {
    let sourceName: String?
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    var isLiked: Bool = false // Local property

    enum CodingKeys: String, CodingKey {
        case source
        case author, title, description, url, urlToImage, publishedAt
    }

    enum SourceKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sourceContainer = try container.nestedContainer(keyedBy: SourceKeys.self, forKey: .source)
        sourceName = try sourceContainer.decodeIfPresent(String.self, forKey: .name)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        publishedAt = try container.decode(String.self, forKey: .publishedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(url, forKey: .url)
        try container.encode(urlToImage, forKey: .urlToImage)
        try container.encode(publishedAt, forKey: .publishedAt)
        
        var sourceContainer = container.nestedContainer(keyedBy: SourceKeys.self, forKey: .source)
        try sourceContainer.encode(sourceName, forKey: .name)
    }
}
