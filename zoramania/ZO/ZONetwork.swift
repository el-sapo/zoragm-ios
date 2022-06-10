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
    
    public func getWalletAddress(_ address: [String]) {
        apollo.fetch(query: WalletQuery()) { result in
            switch result {
              case .success(let graphQLResult):
                if let tokens = graphQLResult.data?.tokens.nodes {
                    print("success")
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
}
