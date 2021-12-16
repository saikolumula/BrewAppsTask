//
//  ParamEncoding.swift
//  TrukkerLoad
//
//  Created by Sunith on 10/11/21.
//

import Foundation

class ParamEncoding {
    class func encodeParam(kvPair: (String, Any)) -> String {
        let key = kvPair.0
        let value = kvPair.1
        if let newValue = value as? String, let encoded = encode(newValue) {
            return "\(key)=\(encoded)"
        }
        return "\(key)=\(value)"
    }

    class func encode(_ value: String) -> String? {
        let cs =  CharacterSet(charactersIn: "+=\"#%/<>?@\\^`{|}; ").inverted
        guard let encoded = value.addingPercentEncoding(withAllowedCharacters: cs) else {
            return nil
        }
        return encoded
    }
}
