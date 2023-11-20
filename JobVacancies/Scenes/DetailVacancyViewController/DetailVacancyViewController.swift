//
//  DetailVacancyViewController.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 20.11.2023.
//

import UIKit

final class DetailVacancyViewController: UIViewController {
    
    // MARK: - Properties
    private let vacancy: Vacancy
    
    // MARK: - Subviews
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 27)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var salaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var addressView: AddressView = {
        let view = AddressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow(.init(color: .secondaryLabel,
                             opacity: 0.2,
                             sizeOfSet: .zero,
                             radius: 5))
        view.layer.cornerRadius = 10
        view.backgroundColor = .secondarySystemGroupedBackground
        
        return view
    }()
    
    // MARK: - Lifecycle methods
    init(vacancy: Vacancy) {
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
        navigationController?.navigationBar.prefersLargeTitles = false
        
        addSubViews()
        addConstraints()
        setupSubViews()
    }
    
    // MARK: - private methods
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(salaryLabel)
        containerView.addSubview(addressView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            salaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            salaryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            salaryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            addressView.topAnchor.constraint(equalTo: salaryLabel.bottomAnchor, constant: 8),
            addressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            addressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            addressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    private func setupSubViews() {
        nameLabel.text = vacancy.name
        setupSalaryLabel(by: vacancy)
        addressView.set(vacancy: vacancy)
    }
    
    private func setupSalaryLabel(by vacancy: Vacancy) {
        salaryLabel.text = ""
        if let salaryFrom = vacancy.salary?.from {
            salaryLabel.text?.append((vacancy.salary?.to == nil
                                      ? "from".localized + " "
                                      : "") + String(salaryFrom))
        }
        
        if let salaryTo = vacancy.salary?.to {
            salaryLabel.text?.append((vacancy.salary?.from == nil
                                      ? "to".localized + " "
                                      : " - ") + String(salaryTo))
        }
        
        if salaryLabel.text != "" {
            salaryLabel.text?.append(" " + (vacancy.salary?.currency ?? ""))
        }
        
        if let isGross = vacancy.salary?.gross {
            let gross = isGross ? "gross".localized : "net".localized
            salaryLabel.text?.append(" " + gross)
        }
    }
}
