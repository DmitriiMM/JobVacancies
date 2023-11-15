//
//  Vacancy.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import Foundation

struct VacancyResult: Decodable {
    let items: [Vacancy]
}

struct Vacancy: Decodable {
    let name: String
    let salary: Salary
    let employer: Employer
    let snippet: Snippet

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        salary = try container.decode(Salary.self, forKey: .salary)
        employer = try container.decode(Employer.self, forKey: .employer)
        snippet = try container.decode(Snippet.self, forKey: .snippet)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, salary, employer, snippet
    }
}

struct Salary: Decodable {
    let from: Int?
    let to: Int?
    let currency: String
}

struct Employer: Decodable {
    let name: String
    let logo: Logo?
}

struct Logo: Decodable {
    let url: URL?
}

struct Snippet: Decodable {
    let requirement: String?
    let responsibility: String?
}
