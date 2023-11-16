//
//  VacancyLoadManager.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 15.11.2023.
//

import Foundation

protocol VacancyLoadProtocol {
    func getVacancies(for nextPage: Int, with text: String?, onCompletion: @escaping (Result<VacancyResult, Error>) -> Void)
}

class VacancyLoadManager: VacancyLoadProtocol {
    static let shared = VacancyLoadManager()
    private let client = DefaultNetworkClient.shared
    
    func getVacancies(for nextPage: Int, with text: String?, onCompletion: @escaping (Result<VacancyResult, Error>) -> Void) {
        DispatchQueue.main.async {
            let request = VacancyRequest(nextPage: nextPage, text: text)
            
            self.client.send(request: request, type: VacancyResult.self, onResponse: onCompletion)
        }
    }
}
