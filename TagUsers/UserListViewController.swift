//
//  UserListViewController.swift
//  TagUsers
//
//  Created by Bharath Ravindran on 01/03/18.
//  Copyright © 2018 Bharath Ravindran. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var userName: String?
    var userID: Int64?
    
    init(name: String?, userId: Int64?) {
        userName = name
        userID = userId
    }
    
}

protocol UserListViewControllerDelegate {
    func selected(user: User, forRange: NSRange?)
    func updateViewRect() -> CGRect
    func localUsers() -> [User]?
}

class UserListViewController: UIViewController {
    
    var tableView: UITableView?
    var userArray: [User]?
    var delegate: UserListViewControllerDelegate?
    var searchTextRange: NSRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        tableView?.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        addTableView()
        refreshViewFrames()
        
        tableView?.tableFooterView = UIView()
    }
    
    
    // MARK: - Custom methods
    
    func refreshView() {
        refreshViewFrames()
        tableView?.reloadData()
    }
    
    func refreshViewFrames() {
        if let rect = delegate?.updateViewRect() {
            updateView(frame: rect, withAnimation: false)
        } else {
            // Don't update any rect
        }
    }
    
    func updateView(frame: CGRect, withAnimation: Bool) {
        view.frame = frame
        updateTableViewFrame()
        
        if withAnimation {
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            // Do it without animation
        }
    }
    
    func updateTableViewFrame() {
        let tableHeight = userArray!.count * 44
        var tableFrame = view.frame
        let tableY = (tableFrame.size.height - CGFloat(tableHeight))
        tableFrame = CGRect(x: tableFrame.origin.x, y: tableY > 10 ? tableY : 10, width: tableFrame.size.width, height: tableFrame.size.height)
        UIView.animate(withDuration: 0.3) {
            self.tableView?.frame = tableFrame
        }
    }
    
    func addUserListView(inViewController: UIViewController, withDelegate: UserListViewControllerDelegate) {
        delegate = withDelegate
        refreshViewFrames()
        inViewController.addChildViewController(self)
        inViewController.view.addSubview(view)
        didMove(toParentViewController: inViewController)
        inViewController.view.layoutIfNeeded()
    }
    
    func removeUserListView() {
        didMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
    
    func addTableView() {
        tableView = UITableView.init(frame: view.frame)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        update(users: delegate?.localUsers())
    }
    
    func update(users: [User]?) {
        userArray = users
        tableView?.reloadData()
        updateTableViewFrame()
    }
    
    func fetchUsersFromServer() {
        //TODO: Add API call for fetching user list and update the result in userArray
    }
    
    func filterUser(withInputString: String, fromContent: String, withRange: NSRange) {
        searchTextRange = withRange
        
        if fromContent.count > 0 {
            if fromContent.isEmpty || withInputString.isEmpty {
                update(users: delegate?.localUsers())
            } else {
                let filteredUsers = delegate?.localUsers()?.filter({ $0.userName?.lowercased().contains(withInputString.lowercased()) ?? false })
                if filteredUsers?.count ?? 0 > 0 {
                    view.isHidden = false
                    update(users: filteredUsers)
                } else {
                    view.isHidden = true
                }
            }
        } else {
            view.isHidden = true
        }
    }
    
    func isUserMatches(searchText: String) {
        
    }
    
}


// MARK: - TableView delegate and datasource methods

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var userCell: UITableViewCell?
        userCell?.backgroundColor = UIColor.blue
        userCell?.contentView.backgroundColor = UIColor.blue
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") {
            userCell = cell
        } else {
            userCell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        
        userCell?.textLabel?.text = userArray![indexPath.row].userName
        
        return userCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(user: userArray![indexPath.row], forRange: searchTextRange)
        view.isHidden = true
    }
    
}
