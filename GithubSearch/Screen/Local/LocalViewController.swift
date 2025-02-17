//
//  LocalViewController.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import UIKit
import SnapKit
import Combine

class LocalViewController: UIViewController {
    private let vm = LocalViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<String, GitHubUser>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        vm.fetchLocalUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        definesPresentationContext = true
    }
    
    convenience init() {
        self.init(title: "Local")
    }
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Local Users"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true

        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.register(GitHubUserCell.self, forCellReuseIdentifier: GitHubUserCell.reuseIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    // MARK: - Diffable Data Source 구성
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<String, GitHubUser>(tableView: tableView) { (tableView, indexPath, user) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubUserCell.reuseIdentifier, for: indexPath) as? GitHubUserCell else {
                return UITableViewCell()
            }
            cell.configure(with: user)
            
            cell.favoriteTogglePublisher
                .sink { [weak self] isFavorite in
                    var updatedUser = user
                    updatedUser.favorite = isFavorite
                    
                    if !isFavorite {
                        self?.vm.deleteFavoriteUser(updatedUser)
                        self?.vm.fetchLocalUsers()
                    }
                }.store(in: &cell.cancellables)
            return cell
        }
    }
    
    // MARK: - 스냅샷 적용
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, GitHubUser>()
        let sortedKeys = vm.filteredGroupedUsers.keys.sorted()
        for key in sortedKeys {
            snapshot.appendSections([key])
            if let users = vm.filteredGroupedUsers[key] {
                snapshot.appendItems(users, toSection: key)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - ViewModel 바인딩
    private func bind() {
        vm.$filteredGroupedUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchResultsUpdating
extension LocalViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        let pattern = "[^A-Za-z0-9-]+"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: query.utf16.count)
            if regex.firstMatch(in: query, options: [], range: range) != nil {
                ToastManager.shared.showToast(message: "사용자 이름은 영문, 숫자, 하이픈만 입력 가능합니다.")
                return
            }
        }
        
        vm.filteredGroupedUsers = vm.searchUsers(query)
    }
}

// MARK: - UITableViewDelegate (섹션 헤더 구현)
extension LocalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") ?? UITableViewHeaderFooterView(reuseIdentifier: "Header")
        let snapshot = dataSource.snapshot()
        if section < snapshot.sectionIdentifiers.count {
            let sectionTitle = snapshot.sectionIdentifiers[section]
            header.textLabel?.text = sectionTitle
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
