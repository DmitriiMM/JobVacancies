//
//  VacancyRequest.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 15.11.2023.
//

import Foundation

enum Param: String, CodingKey {
    case perPage = "per_page"
    case page
    case searchField = "search_field"
    case text
}

struct RestAppearance {
    static let testBaseUrl = "https://api.hh.ru/vacancies"
    static let prodBaseUrl = "https://api.hh.ru/vacancies"
    
    static var baseUrl: String {
        switch AppInfo.apiServerType {
        case .test: return testBaseUrl
        case .prod: return prodBaseUrl
        }
    }
}

struct VacancyRequest: NetworkRequest {
    let nextPage: Int
    let text: String?
    
    var token: String? {
        AppInfo.apiKey
    }
    
    var endpoint: URL? {
        createEndPoint()
    }
    
    private func createEndPoint() -> URL? {
        var components = URLComponents(string: RestAppearance.baseUrl)
        var queryItems = [
            URLQueryItem(name: Param.perPage.rawValue, value: "\(AppInfo.apiPerPageCount)"),
            URLQueryItem(name: Param.page.rawValue, value: "\(nextPage)")
        ]
        
        if let text = text {
            queryItems.append(URLQueryItem(name: Param.searchField.rawValue, value: "name"))
            queryItems.append(URLQueryItem(name: Param.text.rawValue, value: text.lowercased()))
        }
        
        components?.queryItems = queryItems
        
        return components?.url
    }
}
