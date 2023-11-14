//
//  VacancyCell.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import UIKit

final class VacancyCell: UITableViewCell {
    static let identifier = String(describing: VacancyCell.self)
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var salaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var employerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .white
        imageView.addShadow(.init(color: .black, opacity: 0.1, sizeOfSet: .zero, radius: 2))
        return imageView
    }()
    
    private lazy var requirementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var responsibilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 10
        contentView.addShadow(.init(color: .darkGray,
                                    opacity: 0.2,
                                    sizeOfSet: .zero,
                                    radius: 5))
    }
    
    func configure(by vacancy: Vacancy) {
        nameLabel.text = vacancy.name
        salaryLabel.text = ""
        if let salaryFrom = vacancy.salary.from {
            salaryLabel.text?.append((vacancy.salary.to == nil 
                                      ? "from".localized + " "
                                      : "") + String(salaryFrom))
        }

        if let salaryTo = vacancy.salary.to {
            salaryLabel.text?.append((vacancy.salary.from == nil 
                                      ? "to".localized + " "
                                      : " - ") + String(salaryTo))
        }
        
        if salaryLabel.text != "" {
            salaryLabel.text?.append(" " + vacancy.salary.currency)
        }
        
        employerLabel.text = vacancy.employer.name
//        logoImageView.image = UIImage(systemName: "heart.fill")
        
        if let requirement = vacancy.snippet.requirement {
            requirementLabel.text = requirement
        } else {
            requirementLabel.isHidden = true
        }
        
        if let responsibility = vacancy.snippet.responsibility {
            responsibilityLabel.text = responsibility
        } else {
            responsibilityLabel.isHidden = true
        }
        
    }
    
    private func addSubViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(salaryLabel)
        contentView.addSubview(employerLabel)
        contentView.addSubview(logoImageView)
        contentView.addSubview(requirementLabel)
        contentView.addSubview(responsibilityLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -8),
            
            salaryLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            salaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            salaryLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -8),
            
            employerLabel.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            employerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            employerLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -8),
            
            requirementLabel.topAnchor.constraint(equalTo: employerLabel.bottomAnchor, constant: 8),
            requirementLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            requirementLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            responsibilityLabel.bottomAnchor.constraint(equalTo: requirementLabel.bottomAnchor, constant: 20),
            responsibilityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            responsibilityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func calculateCellHeight(with vacancy: Vacancy) -> CGFloat {
        switch (vacancy.snippet.requirement == nil, vacancy.snippet.responsibility == nil) {
        case (true, true):
            return 148
        case (false, true):
            return 168
        case (true, false):
            return 168
        case (false, false):
            return 188
        }
    }
}
