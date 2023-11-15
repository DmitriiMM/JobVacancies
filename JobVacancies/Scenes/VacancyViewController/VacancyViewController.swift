//
//  VacancyViewController.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import UIKit

class VacancyViewController: UIViewController {
    
    // MARK: - Properties
    private var vacancies: [Vacancy] = []
    private let loadManager = VacancyLoadManager.shared
    private var isScrolledToEnd = false
    private var nextPage: Int = 0
    
    // MARK: - Subviews
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
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupSubviews()
        loadData(for: nextPage)
    }
    
    // MARK: - Private methods
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
    
    private func loadData(for nextPage: Int) {
        if nextPage == 0 {
            UIBlockingProgressHUD.show()
        }
        loadManager.getVacancies(for: nextPage) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.nextPage += 1
                    self.isScrolledToEnd = false
                    let oldCountVacancies = self.vacancies.count
                    self.vacancies.append(contentsOf: result.items)
                    self.tableView.performBatchUpdates({
                        let indexPaths = (oldCountVacancies ..< (oldCountVacancies + result.items.count)).map { IndexPath(row: $0, section: 0) }
                        self.tableView.insertRows(at: indexPaths, with: .automatic)
                    }, completion: nil)
                case .failure(let error):
                    self.presentErrorDialog(message: error.localizedDescription)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
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

// MARK: - UITableViewDelegate UITableViewDataSource
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
