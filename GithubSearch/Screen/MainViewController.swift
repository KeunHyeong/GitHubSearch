//
//  ViewController.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import UIKit
import SnapKit
import Combine
import Parchment

class MainViewController: UIViewController {
    private let pagingViewController: PagingViewController = {
        let apiVC = UINavigationController(rootViewController: ApiSearchViewController())
        let localVC = UINavigationController(rootViewController: LocalViewController())
        let viewControllers = [apiVC, localVC]
        
        return PagingViewController(viewControllers: viewControllers)
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Github Stars"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setLayout()
        setupPagingViewController()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func setupPagingViewController() {
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        pagingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}


