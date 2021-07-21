//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var message : [Messages] = [
        Messages(sender: "abcd@yo.in", body: "Hey!!"),
        Messages(sender: "abcd@gmail.com", body: "Hello, How are you ?? I am doing well, I am learning Ios Development with so much desire that I like to work in a great company one day like others. I also want to post picture of my goodie!!!"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil),
                           forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print(signOutError)
        }
        
    }
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
}

extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,
                                                for: indexPath) as! MessageCell
        cell.message.text = message[indexPath.row].body
        return cell
    }
        
}
