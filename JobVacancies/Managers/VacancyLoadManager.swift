//
//  VacancyLoadManager.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 15.11.2023.
//

import Foundation

protocol VacancyLoadProtocol {
    func getVacancies(for nextPage: Int, onCompletion: @escaping (Result<VacancyResult, Error>) -> Void)
}

class VacancyLoadManager: VacancyLoadProtocol {
    static let shared = VacancyLoadManager()
    private let client = DefaultNetworkClient.shared
    
    func getVacancies(for nextPage: Int, onCompletion: @escaping (Result<VacancyResult, Error>) -> Void) {
        let request = VacancyRequest(nextPage: nextPage)
        
        client.send(request: request, type: VacancyResult.self, onResponse: onCompletion)
    }
}
