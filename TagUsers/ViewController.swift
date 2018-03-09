//
//  ViewController.swift
//  TagUsers
//
//  Created by Bharath Ravindran on 01/03/18.
//  Copyright © 2018 Bharath Ravindran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageBGView: UIView!
    
    var userListViewController: UserListViewController?
    
    
    // MARK: - View life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Custom methods
    
    func initializeUserListSearch() {
        if userListViewController == nil {
            userListViewController = UserListViewController()
            userListViewController?.addUserListView(inViewController: self, withDelegate: self)
        } else {
            // Already added
        }
    }
    
    func fetchLocalUsersList() -> [User] {
        let user1 = User(name: "abcd", userId: 1)
        let user2 = User(name: "defg", userId: 2)
        let user3 = User(name: "check out", userId: 3)
        let user4 = User(name: "whats new", userId: 4)
        let user5 = User(name: "check what", userId: 5)
        let user6 = User(name: "yes", userId: 6)
        let user7 = User(name: "test case", userId: 7)
        let user8 = User(name: "dummy data", userId: 8)
        let user9 = User(name: "dummy content", userId: 1)
        let user10 = User(name: "merge", userId: 2)
        let user11 = User(name: "wallet 1", userId: 3)
        let user12 = User(name: "not applicable", userId: 4)
        let user13 = User(name: "check this out large text in this case check this out large text in this case", userId: 5)
        let user14 = User(name: "old", userId: 6)
        let user15 = User(name: "new content", userId: 7)
        let user16 = User(name: "hi hi hi", userId: 8)
        return [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10, user11, user12, user13, user14, user15, user16]
    }
    
}

extension ViewController: UserListViewControllerDelegate {
    
    func result(value: String?, withUser: User) {
        messageTextView.text = value
    }
    
    func updateViewRect() -> CGRect {
        let x: CGFloat = messageBGView.frame.origin.x
        let y: CGFloat = navigationController?.navigationBar.frame.height ?? 0
        let width: CGFloat = messageBGView.frame.size.width
        let height: CGFloat = ((UIScreen.main.bounds.height - y) - (UIScreen.main.bounds.height - messageBGView.frame.origin.y)) // Screen area above the messageBGView
        let messageFrame = CGRect(x: x, y: y, width: width, height: height)
        return messageFrame
    }
    
    func localUsers() -> [User]? {
        return fetchLocalUsersList()
    }
    
}


// MARK: - UITextViewDelegate methods

extension ViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Show tag list when @ is entered
        if textView == messageTextView {
            if text == "@" {
                initializeUserListSearch()
            }
        }
        
        return userListViewController?.filterResultFor(textView: textView, range: range, text: text) ?? true
    }
    
}
