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
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        contentView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let margins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 18
    }
    
    func configure(by vacancy: Vacancy) {
        contentView.layoutIfNeeded()
        
        let fittingSize = CGSize(width: contentView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(fittingSize)
        
        frame.size.height = size.height
        
        nameLabel.text = vacancy.name
    }
    
    private func addSubViews() {
        contentView.addSubview(nameLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}
