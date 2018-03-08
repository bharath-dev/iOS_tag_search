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
    
    func addUserList() {
        if userListViewController == nil {
            userListViewController = UserListViewController()
            userListViewController?.addUserListView(inViewController: self, withDelegate: self)
        } else {
            // Already added
        }
    }
    
    func removeUserList() {
        userListViewController?.view.isHidden = true
    }
    
    func showUserList() {
        if let _ = userListViewController {
            userListViewController?.view.isHidden = false
        } else {
            addUserList()
        }
    }
    
    func performActionForSelected(user: User, forRange: NSRange?) {
        // source text is converted to NSString for some basic API availabilities
        let currentText = messageTextView.text as NSString?
        
        // Get current cursor position
        let cursorPosition = messageTextView.offset(from: messageTextView.beginningOfDocument, to: (messageTextView.selectedTextRange?.start)!)
        
        // Get string till the cursor current position where we need to enter the selected user name
        let textViewContent = currentText?.substring(to: cursorPosition)
        
        // Get the search string by seperating the above text using @ and take the last string where we need to enter the selected user name
        if let searchString = textViewContent?.components(separatedBy: "@").last {
            if searchString.isEmpty { // If no search string entered just append the selected name in source view
                messageTextView.text = "\(messageTextView.text ?? "")\(user.userName ?? "No Name")"
            } else if let searchStringRange = (textViewContent as NSString?)?.range(of: "@\(searchString)", options: .backwards) { // If any search string present then replace that string with selected name in source view
                let newString = currentText?.replacingCharacters(in: searchStringRange, with: "@\(user.userName ?? "") ")
                messageTextView.text = newString
            }
        } else {
            // Don't update the text view unless the above case satisfies
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
    
    func selected(user: User, forRange: NSRange?) {
        performActionForSelected(user: user, forRange: forRange)
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
        let currentText = textView.text as NSString?
        let textViewContent = currentText?.replacingCharacters(in: range, with: text)
        
        // Hide the tag list when no text in textView
        // Ignore empty spaces and new line character
        if textViewContent?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 <= 0 {
            userListViewController?.filterUser(withInputString: "", fromContent: "", withRange: range)
            return true
        }
        
        // Show tag list when @ is entered
        if textView == messageTextView {
            if text == "@" {
                showUserList()
            }
        }
        
        // Search for search string
        if userListViewController != nil {
            let textViewString = textViewContent as NSString?
            let searchTextContent = textViewString?.substring(to: range.location + text.count)
            let searchText = searchTextContent?.components(separatedBy: "@").last?.replacingOccurrences(of: "@", with: "")
            userListViewController?.filterUser(withInputString: searchText ?? "", fromContent: "\(textView.text ?? "")\(textViewContent ?? "")", withRange: range)
        }
        
        return true
    }
    
}
