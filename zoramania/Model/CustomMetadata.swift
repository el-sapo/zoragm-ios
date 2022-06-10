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
    var animationUrl: String?
    var attributes: [Attribute]?
}

struct Attribute: Decodable {
    let trait_type: String?
    let value: String?
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
                    self.imageUrl = imgString
                } else {
                    // this field sometimes comes as data, add parse for this type
                    print("metadata image path is not string")
                }
            } else if item.key == "attributes" {
                // parse atrributes
            } else if item.key == "animation_url" {
                self.animationUrl = item.value as? String
            }
        }
    }
}