//
//  SuggestsRequest.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 22.11.2023.
//

import Foundation

struct SuggestsRequest: NetworkRequest {
    let text: String
    
    var token: String? {
        OAuthTokenStorage.shared.token
    }
    
    var endpoint: URL? {
        createEndPoint()
    }
    
    private func createEndPoint() -> URL? {
        var components = URLComponents(string: "\(RestAppearance.baseUrl)/suggests/positions")
        
        let queryItems = [
            URLQueryItem(name: Param.text.rawValue, value: text.lowercased())
        ]
        
        components?.queryItems = queryItems
        
        return components?.url
    }
}
