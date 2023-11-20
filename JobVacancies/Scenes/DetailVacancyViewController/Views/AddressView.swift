//
//  AddressView.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 20.11.2023.
//

import UIKit
import MapKit

final class AddressView: UIView {
    
    
    // MARK: - Properties
    private var heightMapConstraint = NSLayoutConstraint()
    private var heightLogoConstraint = NSLayoutConstraint()
    
    // MARK: - Subviews
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 8
        return map
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Lifecycle methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(mapView)
        addSubview(addressLabel)
    }
    
    private func addConstraints() {
        heightMapConstraint = mapView.heightAnchor.constraint(equalToConstant: 300)
        heightMapConstraint.isActive = true
        
        heightLogoConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 50)
        heightLogoConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            mapView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    private func setupSubviews(by vacancy: Vacancy) {
        setupLabels(with: vacancy)
        
        if let url = vacancy.employer?.logo?.url {
            loadLogo(from: url)
        } else {
            logoImageView.isHidden = true
            heightLogoConstraint.isActive = false
        }
        guard let latitude = vacancy.address?.lat,
              let longitude = vacancy.address?.lng
        else {
            heightMapConstraint.isActive = false
            return
        }
        setCoordinates(latitude, longitude)
        
    }
    
    private func setupLabels(with vacancy: Vacancy) {
        if let employerName = vacancy.employer?.name {
            nameLabel.text = employerName
        }
        
        if let city = vacancy.address?.city,
           let street = vacancy.address?.street {
            addressLabel.text = "\(city)\n\(street)"
        }
    }
     
    private func setCoordinates(_ latitude: Double, _ longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    private func loadLogo(from stringUrl: String) {
        guard let encodedStringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedStringUrl)
        else { return }
        logoImageView.setImage(from: url)
    }
    
    // MARK: - methods
    func set(vacancy: Vacancy) {
        setupSubviews(by: vacancy)
    }
}
