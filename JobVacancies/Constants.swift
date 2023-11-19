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
    static let apiClientId = "G8PES74OCQD4S8JD1SEN4QU6788IM4BCQONP9PFFVSJV3HAAVF3FGRG00A8BR0VE"
    static let apiClientSecret = "U99T820DQBDSB4V1HAT89T2Q7RH1624T5874F1H3PDRJDEIUR88RK1AAR8OCT4HC"
    static let apiBearerToken = "APPLGQ44PSFVR03SN94P7HIFB9CF9N71HND4BT666H3VM66L11RKPOSK44RQD3IP"
}
