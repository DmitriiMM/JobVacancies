//
//  Constants.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 15.11.2023.
//

import UIKit

enum AppScheme {
    case test
    case prod
}

struct AppInfo {
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    static let apiServerType = AppScheme.test
    static let apiPerPageCount = 20
}
