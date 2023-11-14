//
//  Vacancy.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import UIKit

struct Vacancy {
    let name: String
    let salary: Salary
    let employer: Employer
    let snippet: Snippet
}

struct Salary {
    let from: Int?
    let to: Int?
    let currency: String
}

struct Employer {
    let name: String
    let logo: Logo?
}

struct Logo {
    let url: URL?
}

struct Snippet {
    let requirement: String?
    let responsibility: String?
}
