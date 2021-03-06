//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Muhammad Usman Tatla on 16/11/2020.
//  Copyright © 2020 Essential Developer Ltd. All rights reserved.
//

import Foundation

class FeedImageMapper {
    static func  map(data: Data, httpResponse: HTTPURLResponse) throws -> [FeedImage]{
        guard httpResponse.statusCode == 200, let decodedItems = try? JSONDecoder().decode(FeedImageApiRoot.self, from: data)  else {throw(RemoteFeedLoader.Error.invalidData)}
        return decodedItems.feedImagesArray
    }
    
    private struct FeedImageApiRoot: Decodable{
        private let items: [FeedImageApiModel]
        var feedImagesArray: [FeedImage] {
            return items.map({$0.toFeedImage()})
        }
    }
    
    private struct FeedImageApiModel: Decodable {
        private let image_id: UUID
        private let image_desc: String?
        private let image_loc: String?
        private let image_url: URL
        
        func toFeedImage() -> FeedImage {
            return FeedImage(id: image_id, description: image_desc, location: image_loc, url: image_url)
        }
    }
}
