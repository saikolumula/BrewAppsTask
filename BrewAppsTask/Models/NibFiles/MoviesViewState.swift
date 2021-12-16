//
//  ServiceLinesViewState.swift
//  TrukkerLoad
//
//  Created by Sunith on 28/10/21.
//

import Foundation

struct MoviesViewState {
    init(rows: [Row]) {
        self.rows = rows
    }
    static var empty = MoviesViewState(rows: [])
    var rows: [Row]
    
    enum Row {
        case popularMovie(PopularMovie)
        case unPopularMovie(PopularMovie)
        case empty
    }
}
