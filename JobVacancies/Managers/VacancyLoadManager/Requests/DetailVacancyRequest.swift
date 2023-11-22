//
//  DetailVacancyRequest.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 20.11.2023.
//

import Foundation

struct DetailVacancyRequest: NetworkRequest {
    let id: String
    
    var token: String? {
        OAuthTokenStorage.shared.token
    }
    
    var endpoint: URL? {
        URL(string: "\(RestAppearance.baseUrl)/vacancies/\(id)")
    }
}
