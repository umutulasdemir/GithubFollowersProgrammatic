// FollowerListViewModelTests.swift

import XCTest
@testable import GHProgrammatic

class FollowerListViewModelTests: XCTestCase {
    
    var viewModel: FollowerListViewModel!
    var mockFollowerService: MockFollowerService!
    var mockDelegate: MockFollowerListViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockFollowerService = MockFollowerService()
        mockDelegate = MockFollowerListViewModelDelegate()
        viewModel = FollowerListViewModel(delegate: mockDelegate, followerService: mockFollowerService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockFollowerService = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testGetFollowersSuccess() {
        let followers = [FollowerEntity(login: "follower1", avatarUrl: "url1"), FollowerEntity(login: "follower2", avatarUrl: "url2")]
        mockFollowerService.followers = followers
        
        viewModel.getFollowers(username: "testUser", page: 1)
        
        XCTAssertEqual(viewModel.followers.count, 2)
        XCTAssertTrue(mockDelegate.didUpdateFollowersCalled)
    }
    
    func testGetFollowersFailure() {
        mockFollowerService.shouldReturnError = true
        
        viewModel.getFollowers(username: "testUser", page: 1)
        
        XCTAssertTrue(viewModel.followers.isEmpty)
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
    }
    
    func testFilterFollowers() {
        let followers = [FollowerEntity(login: "follower1", avatarUrl: "url1"), FollowerEntity(login: "follower2", avatarUrl: "url2")]
        viewModel.followers = followers
        
        viewModel.filterFollowers(with: "follower1")
        
        XCTAssertEqual(viewModel.filteredFollowers.count, 1)
        XCTAssertEqual(viewModel.filteredFollowers.first?.login, "follower1")
        XCTAssertTrue(mockDelegate.didUpdateFollowersCalled)
    }
}

// Mock FollowerListViewModelDelegate
class MockFollowerListViewModelDelegate: FollowerListViewModelDelegate {
    
    var didUpdateFollowersCalled = false
    var didFailWithErrorCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showEmptyStateCalled = false
    
    func didUpdateFollowers() {
        didUpdateFollowersCalled = true
    }
    
    func didFailWithError(_ error: ErrorMessage) {
        didFailWithErrorCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func showEmptyState(message: String) {
        showEmptyStateCalled = true
    }
}
