//
//  VacancyViewController.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import UIKit

class VacancyViewController: UIViewController {
    private let vacancies = [
        Vacancy(name: "Developer", salary: Salary(from: 80000, to: 120000, currency: "RUR"), employer: Employer(name: "Apple", logo: nil), snippet: Snippet(requirement: "Get the latest information about Apple products in one place, including information about repairs, technical support cases and much more.", responsibility: "including information about repairs, technical support cases and much moGet the latest information about Apple products in one place, including information about repairs, technical support cases and much more.")),
        Vacancy(name: "DeveloperDeveloper Developer", salary: Salary(from: 8120000, to: 12120000, currency: "RUR"), employer: Employer(name: "Apple", logo: nil), snippet: Snippet(requirement: nil, responsibility: nil)),
        Vacancy(name: "DeveloperDeveloper Developer", salary: Salary(from: 8120000, to: 12120000, currency: "RUR"), employer: Employer(name: "Apple", logo: nil), snippet: Snippet(requirement: nil, responsibility: "Get the latest information about Apple products in one place, including information about repairs, technical support cases and much more.")),
        Vacancy(name: "Developer", salary: Salary(from: nil, to: 120000, currency: "RUR"), employer: Employer(name: "AppleAppleAppleAppleAppleAppleApple", logo: nil), snippet: Snippet(requirement: "Get the latest information about Apple products in one place, including information about repairs, technical support cases and much more.", responsibility: nil))
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(VacancyCell.self, forCellReuseIdentifier: VacancyCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupSubviews()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "vacancies".localized
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search".localized
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension VacancyViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        
        tableView.reloadData()
    }
}

extension VacancyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension VacancyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VacancyCell.identifier,
                                                       for: indexPath) as? VacancyCell else { return UITableViewCell() }
        cell.configure(by: vacancies[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vacancy = vacancies[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VacancyCell.identifier) as? VacancyCell else { return CGFloat() }
        
        return cell.calculateCellHeight(with: vacancy)
    }
}
