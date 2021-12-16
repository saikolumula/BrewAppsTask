//
//  String+Extension.swift
//  TrukkerLoad
//
//  Created by Sunith on 08/11/21.
//

import Foundation
import UIKit

public extension String {
    var length: Int {
        self.count
    }
    func convertSnakeToCamelCase() -> String {
        var newStr = ""
        let parts = self.components(separatedBy: "_")
        if parts.count > 1 {
            parts.enumerated().forEach { (index, part) in
                if index == 0 {
                    newStr.append(part.lowercased())
                } else {
                    newStr.append(part.capitalizingFirst())
                }
            }
        } else {
            return self
        }
        return newStr
    }
    func stringWithSeperator () -> String {
        var resultString: String?
        let length = self.length
        let index = length % 3
        switch index {
        case _ where index > 0 && index < 3 && length > 3:
             resultString = self.insert(",", index: index)
        case _ where index == 0 && length > 5:
            resultString = self.insert(",", index: 1)
            resultString = resultString?.insert(",", index: 4)
        default:
            resultString = self
        }
        return resultString!
    }
    func insert(_ string: String, index: Int) -> String {
        String(self.prefix(index)) + string + String(self.suffix(self.count-index))
    }
    func toDateTime() -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // "2015-11-20T10:57:29Z";
        // Parse into NSDate
        let date: Date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date)
        // Return Parsed Date
        return dateString
    }
    func toDateString() -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd" // "2015-11-20";
        // Parse into NSDate
        let date: Date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "dd MMM, yyyy" // "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date)
        // Return Parsed Date
        return dateString
    }
    func firstChar() -> String {
        if self.length > 0 {
            return String(prefix(1))
        } else {
            return ""
        }
    }
     func capitalizingFirst() -> String {
        if self.length > 0 {
            return prefix(1).uppercased() + dropFirst().lowercased()
        } else {
            return ""
        }
    }
    mutating func capitalizeFirst() {
        if self.length > 0 {
            self = self.capitalizingFirst()
        }
    }
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }
    func removeNewlines() -> String {
        let components = self.components(separatedBy: "\n")
        let result = components.reduce("") { (result, component) -> String in
            if component.trimmingCharacters(in: .whitespaces) != "" {
                return result + " " + component
            } else {
                return result
            }
        }
        return result.trimmingCharacters(in: .whitespaces)
    }
}

@objc public extension NSString {
    func substring(tillFirstOcuuranceOf string: String) -> String {
        let range: NSRange = self.range(of: string)
        if(range.location != NSNotFound) {
            let result: String = self.substring(to: range.location)
            return result
        }
        return ""
    }
    func dropLastCharacter() -> String {
        var str = self as String
        str = String(str.dropLast())
        return str
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }
}

extension String {
    func removeNumberFormat() -> String {
        self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    }
}

extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence, Index> {
            sequence(state: startIndex) { start in
                guard start < self.endIndex else { return nil }
                let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
                defer { start = end }
                return self[start..<end]
            }
        }
    func every(n: Int) -> UnfoldSequence<Element, Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { index = self.index(index, offsetBy: n, limitedBy: endIndex) ?? endIndex }
            return self[index]
        }
    }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func attributedString(_ string: String, withFont font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }
}

extension String {
    func url(_ params: [String: Any]) -> URL? {
        var queryItems: [[String: Any]] = [[String: Any]]()
        var urlComponents = URLComponents(string: self)
        var encodedQuery = ""
        if !params.isEmpty {
            for (key, value) in params {
                queryItems.append([key: value])
            }
            encodedQuery = params.map({ (key, value) -> String in
                ParamEncoding.encodeParam(kvPair: (key, value))
            }).joined(separator: "&")
        }
        // Keep this code as is as percentEncodedQuery will throw if the encodedQuery is not valid urlQuery.
        // As we can not remove selective warning in swift we have to live with this. If you see this code and Apple have added such feature then please change.
        do {
            try urlComponents?.percentEncodedQuery = encodedQuery
        } catch {
            fatalError("\(error)")
        }
        if let url = urlComponents?.url {
            return url
        }
        return nil
    }
}
