//
//  VacancyCell.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import UIKit

final class VacancyCell: UITableViewCell {
    static let identifier = String(describing: VacancyCell.self)
    
    private var trailingConstraint = NSLayoutConstraint()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var salaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var employerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var mainInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private lazy var requirementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var responsibilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .secondarySystemGroupedBackground
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
        contentView.addShadow(.init(color: .secondaryLabel,
                                    opacity: 0.2,
                                    sizeOfSet: .zero,
                                    radius: 5))
    }
    
    func configure(by vacancy: Vacancy) {
        nameLabel.text = vacancy.name
        employerLabel.text = vacancy.employer.name
        
        setupSalaryLabel(by: vacancy)
        setupDescriptionLabels(by: vacancy)
        
        if let url = vacancy.employer.logo?.url {
            loadLogo(from: url)
        } else {
            logoImageView.isHidden = true
            trailingConstraint.isActive = false
            mainInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
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
    }
    
    private func setupDescriptionLabels(by vacancy: Vacancy) {
        let requirementText = vacancy.snippet?.requirement ?? ""
        let responsibilityText = vacancy.snippet?.responsibility ?? ""
        requirementLabel.text = requirementText
        responsibilityLabel.text = responsibilityText
        requirementLabel.isHidden = requirementText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        responsibilityLabel.isHidden = responsibilityText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func loadLogo(from stringUrl: String) {
        guard let encodedStringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedStringUrl)
        else { return }
        logoImageView.setImage(from: url)
    }
    
    private func addSubViews() {
        contentView.addSubview(mainInfoStackView)
        mainInfoStackView.addArrangedSubview(nameLabel)
        mainInfoStackView.addArrangedSubview(salaryLabel)
        mainInfoStackView.addArrangedSubview(employerLabel)
        contentView.addSubview(logoImageView)
        contentView.addSubview(requirementLabel)
        contentView.addSubview(responsibilityLabel)
    }
    
    private func addConstraints() {
        trailingConstraint = mainInfoStackView.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -8)
        trailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            mainInfoStackView.topAnchor.constraint(equalTo: logoImageView.topAnchor),
            mainInfoStackView.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            mainInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            requirementLabel.topAnchor.constraint(equalTo: mainInfoStackView.bottomAnchor, constant: 8),
            requirementLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            requirementLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            responsibilityLabel.topAnchor.constraint(equalTo: requirementLabel.bottomAnchor, constant: 8),
            responsibilityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            responsibilityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            responsibilityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            UIView.animate(withDuration: 0.9) {
                self.contentView.backgroundColor = .gray.withAlphaComponent(0.1)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: 0.5) {
                    self.contentView.backgroundColor = .secondarySystemGroupedBackground
                }
            }
        }
    }
}
