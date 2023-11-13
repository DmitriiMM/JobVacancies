//
//  VacancyViewController.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import UIKit

class VacancyViewController: UIViewController {
    private let vacancies = [Vacancy(name: "Developer"),
                             Vacancy(name: "Engineer"),
                             Vacancy(name: "Data Scientist"),
                             Vacancy(name: "Chef"),
                             Vacancy(name: "Driver")]
    
    private lazy var searchField: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.barTintColor = .white
        search.placeholder = "search".localized
        search.delegate = self
        search.searchBarStyle = .minimal
        
        return search
    }()
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "vacancies".localized
        
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(searchField)
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
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
}

