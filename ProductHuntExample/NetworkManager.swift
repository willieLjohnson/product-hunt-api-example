//
//  Networking.swift
//  ProductHuntExample
//
//  Created by Willie Johnson on 6/29/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
  let urlSession = URLSession.shared
  var baseURL = "https://api.producthunt.com/v1/"

  func getPosts(completion: @escaping ([Post]) -> Void) {
      let request = makePostsRequest()
      urlSession.dataTask(with: request) { data, response, error in
        // Check for errors.
        if error != nil {
          return
        }

        // Check to see if there is any data that was retrieved.
        guard let data = data else {
          return
        }

        // Attempt to decode the data.
        guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
          return
        }

        // Check to see if there is are any posts that were decoded successfully.
        guard let posts = result.posts else {
          return
        }

        // Return the result with the completion handler.
        completion(posts)
      }.resume()
  }

  /// Constructs a request to get featured posts from Product Hunt.
  func makePostsRequest() -> URLRequest {
    // Construct the URL to get posts from API.
    let fullURL = URL(string: baseURL + "posts/all?sort_by=votes_count&order=desc&search[featured]=true&per_page=20")!
    var request = URLRequest(url: fullURL)

    request.httpMethod = "GET"

    // Set up header with API Token.
    request.allHTTPHeaderFields = [
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer eb715e9a4c4dd4f7eaf72222e75db6fbbd61e49aaa06127fca1494a0c0cac1c6", // TODO: \(token)
      "Host": "api.producthunt.com"
    ]
    return request
  }
}