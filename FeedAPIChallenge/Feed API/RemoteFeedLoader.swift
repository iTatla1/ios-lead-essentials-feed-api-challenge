//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) {[weak self] result in
            guard self != nil else {return}
            switch result {
            case let .success((data, response)):
                do {
                    let images = try FeedImageMapper.map(data: data, httpResponse: response)
                    completion(.success(images))
                }
                catch _ {
                    completion(.failure(Error.invalidData))
                }
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
            
        }
    }
}
