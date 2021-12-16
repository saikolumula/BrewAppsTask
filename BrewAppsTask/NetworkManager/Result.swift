//
//  Result.swift
//  TrukkerLoad
//
//  Created by Sunith on 23/11/21.
//
import Foundation
class MoviesResult<T>: Codable where T: Codable {
    var dates:Dates?
    var page:Int
    var results: T
    var total_pages:Int
    var total_results:Int
    
    private enum CodingKeys: String, CodingKey {
        case dates = "dates"
        case page = "page"
        case results = "results"
        case total_pages = "total_pages"
        case total_results = "total_results"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dates = try values.decode(Dates.self, forKey: .dates)
        page = try values.decode(Int.self, forKey: .page)
        results = try values.decode(T.self, forKey: .results)
        total_results = try values.decode(Int.self, forKey: .total_results)
        total_pages = try values.decode(Int.self, forKey: .total_pages)
   }
}
