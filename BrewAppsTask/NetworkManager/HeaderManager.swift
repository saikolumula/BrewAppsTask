//
//  HeaderManager.swift
//  TrukkerLoad
//
//  Created by Sunith on 11/11/21.
//

import Foundation

import UIKit

@objcMembers
class HeaderManager: NSObject {
    static let shared = HeaderManager()
    private var headers = [String: String]()
    private override init() {
        super.init()
        setDeafultHeaders()
    }
    func setDeafultHeaders() {

        if headers.count > 0 {
            headers = [String: String]()
        }
        headers["Accept"] = "application/json"
        headers["device-type"] = UIDevice.current.systemName
        headers["os"] = "iOS_\(UIDevice.current.systemVersion)"
        headers["Content-Type"] = "application/json"
    }
    func getHeaders() -> [String: String] {
        headers
    }
}
