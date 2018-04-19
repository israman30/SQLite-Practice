//
//  ViewController.swift
//  SQLite-Test
//
//  Created by Israel Manzo on 4/17/18.
//  Copyright © 2018 Israel Manzo. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var dataBase: Connection!
    
    let userTable = Table("user")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    let createTable: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Create Table", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(table), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Create table function
    @objc func table(){
        print("Table")
        let createTable = self.userTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
        }
        
        do {
            try self.dataBase.run(createTable)
            print("Table Created")
        } catch {
            print("Error")
        }
    }
    
    let insertUser: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Insert User", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(userInsert), for: .touchUpInside)
        return btn
    }()
    
    @objc func userInsert(){
        print("Insert User")
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "email"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text,
                let email = alert.textFields?.last?.text else {return}
            print(name)
            print(email)
            
            let insertUser = self.userTable.insert(self.name <- name, self.email <- email)
            
            do {
                try self.dataBase.run(insertUser)
                print("Inserted User")
            } catch {
                print("Error")
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    let listUser: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("List User", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(userList), for: .touchUpInside)
        return btn
    }()
    
    @objc func userList(){
        print("List User")
        do {
            let users = try self.dataBase.prepare(userTable)
            for user in users {
                print("userId: \(user[id]), name: \(user[name]), email: \(user[email])")
            }
        } catch {
            print("Error listing user")
        }
    }
    
    let updateUser: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Insert User", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(userUpdate), for: .touchUpInside)
        return btn
    }()
    
    @objc func userUpdate(){
        print("Upadate User")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "User id"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "email"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
                let email = alert.textFields?.last?.text else {return}
            print(userIdString)
            print(email)
            
            let 
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    let deleteUser: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Insert User", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(userDelete), for: .touchUpInside)
        return btn
    }()
    
    @objc func userDelete(){
        print("Delete User")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "User id"
        }
        
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text else {return}
            print(userIdString)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        do {
            // We using a document manager to create a location file for storage
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // Creating a file
            let fileUrl = documentDirectory.appendingPathComponent("user").appendingPathExtension("sqlite3")
            // With this path the db will be access from different methods
            let dataBase = try Connection(fileUrl.path )
            self.dataBase = dataBase
        } catch {
                print("error")
        }
        
        setView()
        
    }
    
    func setView(){
        
        navigationItem.title = "SQLite test"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        [createTable, insertUser,listUser, updateUser, deleteUser].forEach({view.addSubview($0)})
        
        createTable.frame = CGRect(x: 140, y: 200, width: 100, height: 50)
        insertUser.frame = CGRect(x: 140, y: 300, width: 100, height: 50)
        listUser.frame = CGRect(x: 140, y: 400, width: 100, height: 50)
        updateUser.frame = CGRect(x: 140, y: 500, width: 100, height: 50)
        deleteUser.frame = CGRect(x: 140, y: 600, width: 100, height: 50)
        
    }



}

