//
//  MoviesViewModel.swift
//  BrewAppsTask
//
//  Created by sainath on 03/12/21.
//

import Foundation

class MoviesRespiratory{

    var movies = [PopularMovie]()
    
    func executePopularApiCall(completion: @escaping (Result<[PopularMovie], Error>) -> Void) {
        let params = ["api_key":"a07e22bc18f5cb106bfe4cc1f83ad8ed"]
        NetworkManager(data: [:], params: params,path: WebServiceAPI.popularMovies.path, method: .get, isJSONRequest: false).executeQuery { (result: Result<MoviesResult<[PopularMovie]>, Error>) in
            switch result {
            case .success(let data):
                self.movies.append(contentsOf: data.results)
                filterData.append(contentsOf: data.results)
                DispatchQueue.main.async {
                    completion(.success(data.results))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
