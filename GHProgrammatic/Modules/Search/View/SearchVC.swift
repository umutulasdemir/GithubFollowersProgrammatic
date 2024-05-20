//
//  SearchVC.swift
//
//  Created by Umut Ulaş Demir on 6.05.2024.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = CustomTextField()
    let callToActionButton = CustomButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUsernameEntered: Bool { return !(usernameTextField.text?.isEmpty ?? false) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK: - SET THE VIEW
    func setupUI(){
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureButton()
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configureButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowersList), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    //MARK: - Configure Tap Gesture
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func pushFollowersList(){
        guard isUsernameEntered else {
            presentCustomPopupOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😃.", buttonTitle: "Ok")
            return
        }
        
        
        let followerListVC = FollowerListVC()
        followerListVC.username = usernameTextField.text
        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}

extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Did Tap Return")
        return true
    }
}
