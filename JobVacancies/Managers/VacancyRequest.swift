//
//  VacancyRequest.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 15.11.2023.
//

import Foundation

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
    var endpoint: URL? {
        URL(string: "\(RestAppearance.baseUrl)?per_page=\(AppInfo.apiPerPageCount)&page=\(nextPage)")
    }
}
