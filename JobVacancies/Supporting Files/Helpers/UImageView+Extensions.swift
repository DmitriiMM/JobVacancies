//
//  UImageView+Extensions.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 16.11.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_), .failure(_):
                self.kf.indicatorType = .none
            }
        }
    }
}
