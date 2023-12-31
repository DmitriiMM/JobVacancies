//
//  VacancyViewController.swift
//  JobVacancies
//
//  Created by Дмитрий Мартынов on 14.11.2023.
//

import UIKit
import Combine

final class VacancyViewController: UIViewController {
    
    // MARK: - Properties
    private var visibleVacancies: [Vacancy] = []
    private var vacancies: [Vacancy] = []
    private let loadManager = VacancyLoadManager.shared
    private let oauthTokenStorage = OAuthTokenStorage.shared
    private let oauthService = OAuthService.shared
    private var isNeedNewPage = false
    private var nextPage: Int = 0
    private var searchingText: String?
    
    private var searchSubject = PassthroughSubject<String?, Never>()
    private var observers: Set<AnyCancellable> = []
    
    // MARK: - Subviews
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search".localized
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(VacancyCell.self, forCellReuseIdentifier: VacancyCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = spiner
        return tableView
    }()
    
    private lazy var spiner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView()
        spiner.startAnimating()
        spiner.isHidden = true
        return spiner
    }()
    
    private lazy var emptyListLabel: UILabel = {
        let width = view.frame.width * 0.8
        let height = view.frame.height * 0.4
        let x = view.center.x - width * 0.5
        let y = view.center.y - height * 0.5
        let labelFrame = CGRect(x: x, y: y, width: width, height: height)
        let label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "enterNameToShow".localized
        label.textColor = .secondaryLabel
        label.font = .boldSystemFont(ofSize: 22)
        
        return label
    }()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        loadData(for: nextPage, with: nil)
        setupSubviews()
        setupCombine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "vacancies".localized
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func showEmptyListLabelIfNeeded() {
        if visibleVacancies.isEmpty {
            view.addSubview(emptyListLabel)
        } else {
            emptyListLabel.removeFromSuperview()
        }
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
    
    private func setupCombine() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.searchingText = searchText
                self.loadData(for: self.nextPage, with: searchText)
            }
            .store(in: &observers)
    }
    
    private func loadData(for nextPage: Int, with text: String?) {
        if !isNeedNewPage {
            UIBlockingProgressHUD.show()
        }
        
        loadManager.getVacancies(for: nextPage, with: text) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if self.isNeedNewPage {
                        self.nextPage += 1
                        self.isNeedNewPage = false
                    }
                    
                    let oldCountVacancies = self.vacancies.count
                    self.vacancies.append(contentsOf: result.items)
                    self.visibleVacancies = self.vacancies
                    self.showEmptyListLabelIfNeeded()
                    self.tableView.performBatchUpdates({
                        let indexPaths = (oldCountVacancies ..< (oldCountVacancies + result.items.count))
                            .map { IndexPath(row: $0, section: 0) }
                        self.tableView.insertRows(at: indexPaths, with: .automatic)
                    }, completion: nil)
                case .failure(let error):
                    self.presentErrorDialog(message: error.localizedDescription)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    @available(iOS 16.0, *)
    private func loadSuggests(for text: String) {
        loadManager.getSuggests(with: text) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.searchController.searchSuggestions = result.items.compactMap {
                        UISearchSuggestionItem(localizedSuggestion: $0.text)
                    }
                case .failure(_):
                    print("Error while getting suggests!")
                    break
                }
            }
        }
    }
    
    private func clearTableView() {
        visibleVacancies = []
        vacancies = []
        nextPage = 0
        showEmptyListLabelIfNeeded()
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
@available(iOS 16.0, *)
extension VacancyViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
    
    func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: UISearchSuggestion) {
        if let text = searchSuggestion.localizedSuggestion {
            searchController.searchBar.text = text
            searchSubject.send(text)
        }
    }
}

// MARK: - UISearchBarDelegate
extension VacancyViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard searchBar.text?.count == 0 else { return true }
        clearTableView()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard 
            searchBar.text?.count != 0
        else {
            clearTableView()
            return
        }
        
        if let previousText = searchingText,
           searchText != previousText {
            clearTableView()
        }
        
        if #available(iOS 16.0, *) {
            guard let searchBarText = searchBar.text,
                  searchText.count > 1
            else { return }
            
            loadSuggests(for: searchBarText)
        } else {
            guard let searchBarText = searchBar.text,
                  searchText.count > 3
            else { return }
            
            searchSubject.send(searchBarText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        navigationItem.searchController?.isActive = false
        searchBar.text = searchBarText
        searchSubject.send(searchBarText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        clearTableView()
        searchingText = nil
        searchSubject.send(searchingText)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension VacancyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vacancy = visibleVacancies[indexPath.row]
        
        loadManager.getVacancyDetail(for: vacancy.id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    let detailVC = DetailVacancyViewController(vacancy: result)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                case .failure(let error):
                    self.presentErrorDialog(message: error.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        spiner.isHidden = (indexPath.row + 1 == visibleVacancies.count) 
        ? !(visibleVacancies.count == AppInfo.apiPerPageCount * (nextPage + 1))
        : true
        
        if tableView.isDragging || tableView.isDecelerating && tableView.scrollsToTop {
            if visibleVacancies.count >= AppInfo.apiPerPageCount * (nextPage + 1) 
                && indexPath.row + 1 == visibleVacancies.count - 5 {
                isNeedNewPage = true
                searchSubject.send(searchingText)
            }
        }
    }
}

extension VacancyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleVacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VacancyCell.identifier,
                                                       for: indexPath) as? VacancyCell else { return UITableViewCell() }
        cell.configure(by: visibleVacancies[indexPath.row])
        
        return cell
    }
}
