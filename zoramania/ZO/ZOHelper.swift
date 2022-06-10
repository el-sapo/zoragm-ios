//
//  ZOHelper.swift
//  zoramania
//
//  Created by Federico Lagarmilla on 9/6/22.
//

import Foundation
import Apollo

/*
struct Token: Codable {
    var metadata: CustomMetadata?
    
    init(token: WalletQuery.Data.Token.Node.Token) {
        self.metadata = token.metadata
    }
}
*/

public enum JSONScalar {
 case dictionary([String: Any])
 case array([Any])
}

extension JSONScalar: JSONDecodable {
    public init(jsonValue value: JSONValue) throws {

        if let dict = value as? [String: Any] {
          self = .dictionary(dict)

        } else if let array = value as? [Any] {
          self = .array(array)

        } else {
          throw JSONDecodingError.couldNotConvert(value: value, to: JSONScalar.self)
        }
    }
}



