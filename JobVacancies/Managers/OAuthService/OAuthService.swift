//
//  OAuthService.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 17.11.2023.
//

import UIKit

final class OAuthService {
    static let shared = OAuthService()
    private var task: URLSessionTask?
    
    func fetchOAuthTokenIfNeeded() {
        guard OAuthTokenStorage.shared.token == nil else { return }
        assert(Thread.isMainThread)
        task?.cancel()
        let request = makeRequest()
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard self != nil else { return }
                switch result {
                case .success(let responseBody):
                    let authToken = responseBody.accessToken
                    OAuthTokenStorage.shared.save(authToken)
                case .failure(let error):
                    let topVC = UIWindow().rootViewController?.presentedViewController
                    topVC?.presentErrorDialog(message: error.localizedDescription)
                }
            }
        }
        self.task = task
    }
    
    private func makeRequest() -> URLRequest {
        var components = URLComponents(string: "https://hh.ru/oauth/token")
        let queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials"),
            URLQueryItem(name: "client_id", value: AppInfo.apiClientId),
            URLQueryItem(name: "client_secret", value: AppInfo.apiClientSecret)
        ]
        components?.queryItems = queryItems
        guard let url = components?.url else { return URLRequest(url: URL(fileURLWithPath: "")) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

