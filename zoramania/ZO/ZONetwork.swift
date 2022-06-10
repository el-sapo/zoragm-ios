//
//  ZONetwork.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 9/6/22.
//

import Foundation
import Apollo

class ZONetwork {
    static let shared = ZONetwork()

    private let zo_api = "https://api.zora.co/graphql"
    private(set) lazy var apollo = ApolloClient(url: URL(string: zo_api)!)
    
    public func getTopCollections() {
        apollo.fetch(query: ListCollectionsQuery()) { result in
            switch result {
              case .success(let graphQLResult):
                if let collections = graphQLResult.data?.collections.nodes {
                    print(collections.count)
                } else if let errors = graphQLResult.errors {
                  // GraphQL errors
                  print(errors)
                }
              case .failure(let error):
                // Network or response format errors
                print(error)
              }
        }
    }
    
    public func getWalletAddresses(_ addresses: [String], completionHandler: @escaping (Result<[CustomMetadata], Error>)->()) {
        apollo.fetch(query: WalletQuery(addresses: addresses)) { result in
            switch result {
              case .success(let graphQLResult):
                if let tokens = graphQLResult.data?.tokens.nodes {
                    var resultTokens: [CustomMetadata] = [];
                    for token in tokens {
                        // JSON deserializer crashes with some contents in metadata, so we have to do it manually
                        switch token.token.metadata {
                        case .dictionary(let metaItems):
                            let metadata = CustomMetadata(items: metaItems)
                            resultTokens.append(metadata)
                        case .array(_):
                            print("metadata should be dictionary")
                        case .none:
                            print("metadata is empty")
                        }
                    }
                    print("tokens found: \(resultTokens.count)")
                    completionHandler(.success(resultTokens))
                } else if let errors = graphQLResult.errors {
                    // GraphQL errors
                    print(errors)
                    let error = NSError(domain: "", code: 200, userInfo: nil)
                    completionHandler(.failure(error))
                }
              case .failure(let error):
                // Network or response format errors
                print(error)
                completionHandler(.failure(error))
              }
        }
    }
}
