//
//  OAuthTokenStorage.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 17.11.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuthTokenStorage {
    static let shared = OAuthTokenStorage()
    var token: String? {
        get {
            AppInfo.apiBearerToken
//            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
    
    private enum Keys: String {
        case token
    }
    
    func save(_ token: String) {
        self.token = token
    }
}
