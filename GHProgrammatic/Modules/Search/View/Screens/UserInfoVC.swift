//
//  UserInfoVC.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 21.05.2024.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var username: String!
    var viewModel: UserInfoViewModel!
    
    let avatarImageView = CustomAvatarImageView(frame: .zero)
    let usernameLabel = UILabel()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    let bioLabel = UILabel()
    let reposLabel = UILabel()
    let gistsLabel = UILabel()
    let followersLabel = UILabel()
    let followingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserInfoViewModel(username: username, delegate: self)
        configureViewController()
        layoutUI()
        viewModel.getUserInfo()
    }
    
    @objc func dismssVC(){
        dismiss (animated: true)
    }
    
    // MARK: - Configure UI
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = username
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismssVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        
        [avatarImageView, usernameLabel, nameLabel, locationLabel, bioLabel, reposLabel, gistsLabel, followersLabel, followingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 28),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: padding),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 90),
            
            reposLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: padding),
            reposLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            reposLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            reposLabel.heightAnchor.constraint(equalToConstant: 28),
            
            gistsLabel.topAnchor.constraint(equalTo: reposLabel.bottomAnchor, constant: 8),
            gistsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            gistsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            gistsLabel.heightAnchor.constraint(equalToConstant: 28),
            
            followersLabel.topAnchor.constraint(equalTo: gistsLabel.bottomAnchor, constant: 8),
            followersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            followersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            followersLabel.heightAnchor.constraint(equalToConstant: 28),
            
            followingLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 8),
            followingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            followingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            followingLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureUIElements(with user: UserEntity) {
        avatarImageView.downloadImage(from: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? "No name available"
        locationLabel.text = user.location ?? "No location available"
        bioLabel.text = user.bio ?? "No bio available"
        reposLabel.text = "Public Repos: \(user.publicRepos)"
        gistsLabel.text = "Public Gists: \(user.publicGists)"
        followersLabel.text = "Followers: \(user.followers)"
        followingLabel.text = "Following: \(user.following)"
    }
}

// MARK: - UserInfoViewModelDelegate

extension UserInfoVC: UserInfoViewModelDelegate {
    func didReceiveUserInfo(_ user: UserEntity) {
        DispatchQueue.main.async {
            self.configureUIElements(with: user)
        }
    }
    
    func didFailWithError(_ error: ErrorMessage) {
        presentCustomPopupOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
    }
    
    func showLoading() {
        showLoadingView()
    }
    
    func hideLoading() {
        dismissLoadingView()
    }
}
