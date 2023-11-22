//
//  Suggests.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 22.11.2023.
//

import Foundation

struct Suggests: Decodable {
    let items: [SuggestItem]
}

struct SuggestItem: Decodable {
    let text: String
}
