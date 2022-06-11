//
//  CustomMetadata.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 9/6/22.
//

import Foundation

struct CustomMetadata: Decodable {
    var name: String?
    var description: String?
    var imageUrl: String?
//    var imageData: Any?
    var animationUrl: String?
    var attributes: [Attribute]?
    var collectionInfo: CollectionInfo?
}

struct Attribute: Decodable {
    let trait_type: String?
    let value: String?
}

struct CollectionInfo: Decodable {
    let collectionAddress: String?
    let collectionName: String?
}

extension CustomMetadata {
    init(items: [String: Any]) {
        for item in items {
            if item.key == "name" {
                self.name = item.value as? String
            } else if item.key == "description" {
                self.description = item.value as? String
            } else if item.key == "image" {
                if let imgString = item.value as? String {
                    self.imageUrl = imgString.replacingOccurrences(of: "ipfs://", with: "https://ipfs.io/ipfs/")
                } 
            } else if item.key == "attributes" {
                // parse atrributes
            } else if item.key == "animation_url" {
                self.animationUrl = item.value as? String
            }
        }
    }
}
