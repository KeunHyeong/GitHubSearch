//
//  GitHubUserCell.swift
//  RememberTest
//
//  Created by 장근형 on 2/6/25.
//

import UIKit
import SnapKit
import Combine
import Kingfisher

class GitHubUserCell: UITableViewCell, ReuseIdentifying {
    private let cellContentView = UIView()
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    
    var cancellables = Set<AnyCancellable>()
    private let favoriteToggleSubject = PassthroughSubject<Bool, Never>()
    
    var favoriteTogglePublisher: AnyPublisher<Bool, Never> {
        favoriteToggleSubject.eraseToAnyPublisher()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let normalImage = UIImage(systemName: "star")!.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "star.fill")!.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.tintColor = .white
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cellContentView)
        cellContentView.addSubview(profileImageView)
        cellContentView.addSubview(usernameLabel)
        cellContentView.addSubview(favoriteButton)
        
        cellContentView.snp.makeConstraints { make in
            make.size.width.equalToSuperview()
            make.size.height.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.size.equalTo(40)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(favoriteButton.snp.leading).offset(-10)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        favoriteToggleSubject.send(favoriteButton.isSelected)
    }
    
    func configure(with user: GitHubUser) {
        usernameLabel.text = user.login
        favoriteButton.isSelected = user.favorite
        
        if let url = URL(string: user.avatarURL) {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.5)),
                    .forceTransition
                ],
                completionHandler: nil
            )
        }
    }
}
