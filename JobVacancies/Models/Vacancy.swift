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
    let id: String
    let name: String
    let salary: Salary?
    let employer: Employer?
    let snippet: Snippet?
    let address: Address?
    let description: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        salary = try container.decodeIfPresent(Salary.self, forKey: .salary)
        employer = try container.decodeIfPresent(Employer.self, forKey: .employer)
        snippet = try container.decodeIfPresent(Snippet.self, forKey: .snippet)
        address  = try container.decodeIfPresent(Address.self, forKey: .address)
        description  = try container.decodeIfPresent(String.self, forKey: .description)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, salary, employer, snippet, address, description
    }
}

struct Salary: Decodable {
    let from: Int?
    let to: Int?
    let currency: String?
    let gross: Bool?
}

struct Employer: Decodable {
    let name: String
    let logo: Logo?
    
    enum CodingKeys: String, CodingKey {
        case name
        case logo = "logo_urls"
    }
}

struct Logo: Decodable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "240"
    }
}

struct Snippet: Decodable {
    let requirement: String?
    let responsibility: String?
}

struct Address: Decodable {
    let city: String?
    let street: String?
    let lat: Double?
    let lng: Double?
}
