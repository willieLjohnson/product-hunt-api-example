//
//  Post.swift
//  ProductHuntExample
//
//  Created by Willie Johnson on 6/29/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation

/// A product retreived from the Product Hunt API.
struct Post {
  let id: Int
  let name: String
  let tagline: String
  let votesCount: Int
  let commentsCount: Int
  let previewImageURL: URL
}

struct PostList: Decodable {
  var posts: [Post]?
}

// MARK: Decodable
extension Post: Decodable {
  enum PostKeys: String, CodingKey {
    case id
    case name
    case tagline
    case votesCount = "votes_count"
    case commentsCount = "comments_count"
    case previewImageURL = "screenshot_url"
  }

  enum PreviewImageURLKeys: String, CodingKey {
    case imageURL = "850px"
  }

  init(from decoder: Decoder) throws {
    let postsContainer = try decoder.container(keyedBy: PostKeys.self)
    id = try postsContainer.decode(Int.self, forKey: .id)
    name = try postsContainer.decode(String.self, forKey: .name)
    tagline = try postsContainer.decode(String.self, forKey: .tagline)
    votesCount = try postsContainer.decode(Int.self, forKey: .votesCount)
    commentsCount = try postsContainer.decode(Int.self, forKey: .commentsCount)

    let screenshotURLContainer = try postsContainer.nestedContainer(keyedBy: PreviewImageURLKeys.self, forKey: .previewImageURL)
    previewImageURL = try screenshotURLContainer.decode(URL.self, forKey: .imageURL)
  }
}
