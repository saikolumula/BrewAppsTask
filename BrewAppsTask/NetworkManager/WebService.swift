//
//  TLWebService.swift
//  TrukkerLoad
//
//  Created by Nandeesh on 18/10/21.
//

import Foundation

struct WebService {

    struct StagingServer {
        static let baseURL = "https://api.themoviedb.org"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

enum WebServiceAPI: String {
    case popularMovies
    case unPopularMovies

    // MARK: API Path
    var path: String {
        switch self {
        case .popularMovies:
            return "3/movie/now_playing?"
        case .unPopularMovies:
            return "3/movie/209112/videos?"
            
        }
    }
}
