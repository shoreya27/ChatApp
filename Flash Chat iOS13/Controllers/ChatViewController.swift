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
    let db = Firestore.firestore()
    var message : [Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil),
                           forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
        print(message)
    }
    
    func loadMessages(){
        //read all messages from db and load
        db.collection(K.FStore.collectionName)
            .order(by: "date")
            //.whereField(K.FStore.senderField, isEqualTo: Auth.auth().currentUser?.email as Any)
            .addSnapshotListener { QuerySnapshot, Error in
            if Error != nil{
                            print("error while reading data from the collection!")
                            }
            else{
                self.message = []
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    self.message.append(
                            Messages(sender: data[K.FStore.senderField] as? String ?? "",
                                     body: data[K.FStore.bodyField] as? String ?? ""
                                    )
                                        )
                }
                //print(self.message)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //scroll to last row
                    self.tableView.scrollToRow(at: IndexPath(row: self.message.count - 1,
                                                             section: 0),
                                               at: .top,
                                               animated: true)
                }
            }
        }
        
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
        if let message = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            db.collection(
                K.FStore.collectionName
            ).addDocument(
                data: [K.FStore.senderField:sender,
                       K.FStore.bodyField:message,
                       K.FStore.dateField:Date().timeIntervalSince1970
                      ]
                    ) { err in
                if let error = err{
                    print("error in saving data \(error)")
                }else{
                    print("saved successfully!!!")
                }
            }
        }
        //emties the textfield
        messageTextfield.text = ""
    }
    
}

extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = message[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,
                                                for: indexPath) as! MessageCell
        cell.message.text = message.body
        //if sender is current user , use different bg color and hide youAvatar
        if message.sender == Auth.auth().currentUser?.email{
            cell.youAvatar.isHidden = true
            cell.meAvatar.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.blue)
            cell.message.textColor = UIColor(named: K.BrandColors.lighBlue)
        }else{
            cell.meAvatar.isHidden = true
            cell.youAvatar.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.message.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
        
}
