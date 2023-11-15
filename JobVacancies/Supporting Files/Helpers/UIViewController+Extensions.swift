//
//  UIViewController+Extensions.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 15.11.2023.
//

import UIKit

extension UIViewController {
    func presentErrorDialog(message: String?) {
        let errorDialog = UIAlertController(title: "error".localized, message: message, preferredStyle: .alert)
        errorDialog.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(errorDialog, animated: true)
    }
}
