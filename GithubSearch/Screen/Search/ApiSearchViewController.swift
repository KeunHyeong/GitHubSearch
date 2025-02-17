//
//  APIViewController.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import UIKit
import SnapKit
import Combine

class ApiSearchViewController: UIViewController {
    private let vm = SearchViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Section, GitHubUser>!
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        view.backgroundColor = .white
    }
    
    convenience init() {
        self.init(title: "API")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search GitHub Users"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.register(GitHubUserCell.self, forCellReuseIdentifier: GitHubUserCell.reuseIdentifier)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, GitHubUser>(tableView: tableView) { tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: GitHubUserCell.reuseIdentifier, for: indexPath) as! GitHubUserCell
            cell.configure(with: user)
            cell.selectionStyle = .none
            
            cell.favoriteTogglePublisher
                .sink { [weak self] isFavorite in
                    var updatedUser = user
                    updatedUser.favorite = isFavorite
                    
                    if isFavorite {
                        self?.vm.saveFavoriteUser(updatedUser)
                    } else {
                        self?.vm.deleteFavoriteUser(updatedUser)
                    }
                }.store(in: &cell.cancellables)
            return cell
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GitHubUser>()
        snapshot.appendSections([.main])
        snapshot.appendItems(vm.users, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bind() {
        vm.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }
            .store(in: &cancellables)
    }
}

extension ApiSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        if query.isEmpty {
            vm.cancel()
            return
        }
        
        let pattern = "[^A-Za-z0-9-]+"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: query.utf16.count)
            if regex.firstMatch(in: query, options: [], range: range) != nil {
                ToastManager.shared.showToast(message: "사용자 이름은 영문, 숫자, 하이픈만 입력 가능합니다.")
                return
            }
        }
        
        vm.searchGitHubUsers(query)
    }
}

extension ApiSearchViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.cancel()
    }
}

extension ApiSearchViewController {
    enum Section {
        case main
    }
}


