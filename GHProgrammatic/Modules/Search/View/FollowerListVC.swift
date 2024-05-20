//
//  FollowerListVC.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 17.05.2024.
//

import UIKit

protocol FollowerListViewModelDelegate: AnyObject {
    func didUpdateFollowers()
    func didFailWithError(_ error: ErrorMessage)
    func showLoading()
    func hideLoading()
}

class FollowerListVC: UIViewController {
    
    enum Section { case main }
    
    // MARK: - Properties
    
    var username: String?
    var viewModel: FollowerListViewModel!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, FollowerEntity>!

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        viewModel = FollowerListViewModel(delegate: self)
        viewModel.username = username
        viewModel.getFollowers(username: username ?? "", page: viewModel.page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI Configuration
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FollowerEntity>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    // MARK: - Data Handling
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowerEntity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard viewModel.hasMoreFollowers else { return }
            viewModel.page += 1
            viewModel.getFollowers(username: viewModel.username ?? "", page: viewModel.page)
        }
    }
}

// MARK: - FollowerListViewModelDelegate

extension FollowerListVC: FollowerListViewModelDelegate {
    func didUpdateFollowers() {
        updateData()
        hideLoading()
    }
    
    func didFailWithError(_ error: ErrorMessage) {
        presentCustomPopupOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
        hideLoading()
    }
    
    func showLoading() {
        showLoadingView()
    }
    
    func hideLoading() {
        dismissLoadingView()
    }
}
