//
//  FollowerListVC.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 17.05.2024.
//

import UIKit

class FollowerListVC: UIViewController {
    
    // MARK: - Section Enum
    
    enum Section { case main }
    
    // MARK: - Properties
    
    var username: String?
    var viewModel: FollowerListViewModel!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, FollowerEntity>!
    var searchController: UISearchController!

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        configureSearchController()
        viewModel = FollowerListViewModel(delegate: self)
        viewModel.username = username
        viewModel.getFollowers(username: username ?? "", page: viewModel.page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Configure UI
    
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
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FollowerEntity>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    // MARK: - Data Handling
    
    private func updateData(on followers: [FollowerEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowerEntity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FollowerListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = viewModel.filteredFollowers[indexPath.item]
        let userInfoVC = UserInfoVC()
        userInfoVC.username = follower.login
        let navController = UINavigationController(rootViewController: userInfoVC)
        present(navController, animated: true)
    }
    
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
        updateData(on: viewModel.filteredFollowers)
        DispatchQueue.main.async {
            self.updateSearchResults(for: self.searchController)
        }
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
    
    func showEmptyState(message: String) {
        showEmptyStateView(with: message, in: view)
    }
}

// MARK: - UISearchResultsUpdating

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            viewModel.filteredFollowers = viewModel.followers
            updateData(on: viewModel.followers)
            return
        }
        
        viewModel.filterFollowers(with: filter)
    }
}
