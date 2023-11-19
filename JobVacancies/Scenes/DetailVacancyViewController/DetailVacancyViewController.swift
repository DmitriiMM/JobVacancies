//
//  DetailVacancyViewController.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 20.11.2023.
//

import UIKit

final class DetailVacancyViewController: UIViewController {
    private let vacancy: VacancyDetail
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(vacancy: VacancyDetail) {
        self.vacancy = vacancy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.items?.first?.title = ""
        
        addSubViews()
        addConstraints()
        setupSubViews()
    }
    
    private func addSubViews() {
        view.addSubview(nameLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSubViews() {
        nameLabel.text = vacancy.name
    }
}
