//
//  OAuthTokenResponseBody.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 17.11.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
    }
    
    let accessToken: String
    let tokenType: String
}

private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
}
