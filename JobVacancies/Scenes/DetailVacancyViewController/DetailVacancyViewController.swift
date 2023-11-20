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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.2901884317, green: 0.699102819, blue: 0.3045158386, alpha: 1)
        button.tintColor = .white
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitle("respond".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(respondButtonTapped), for: .touchUpInside)
        return button
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
        containerView.addSubview(descriptionLabel)
        view.addSubview(button)
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
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -100),
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
            
            descriptionLabel.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 54),
        ])
    }
    
    private func setupSubViews() {
        nameLabel.text = vacancy.name
        setupSalaryLabel(by: vacancy)
        addressView.set(vacancy: vacancy)
        
        if let decodedAttributedString = decodeHTMLString(vacancy.description) {
            let customAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 15)
            ]
            let range = NSRange(location: 0, length: decodedAttributedString.length)
            let attributedString = NSMutableAttributedString(attributedString: decodedAttributedString)
            attributedString.addAttributes(customAttributes, range: NSRange(location: 0, length: decodedAttributedString.length))
            
            descriptionLabel.attributedText = attributedString
        }
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
    
    private func decodeHTMLString(_ htmlString: String?) -> NSAttributedString? {
        guard let data = htmlString?.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString
        } catch {
            print("Error decoding HTML string: \(error)")
            return nil
        }
    }
    
    @objc 
    private func respondButtonTapped() {
        presentDialog(title: "yourResponseHasBeenSent".localized)
    }
}
