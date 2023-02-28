//
//  RecordsVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 07/02/23.
//

import UIKit







class RecordsVC: UIViewController{
    
    
    private lazy var plusBtn = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.imageView?.contentMode = .scaleToFill
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.imageView?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private lazy var table = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(table)
        view.addSubview(plusBtn)
        table.pinToSafeArea(view: view)
        NSLayoutConstraint.activate([
            plusBtn.heightAnchor.constraint(equalToConstant: 60),
            plusBtn.widthAnchor.constraint(equalToConstant: 60),
            plusBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            plusBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ])

       
    }
    
    var expenses = [(amount: Double, category: String,title : String,date : Date,note: String, id : String)]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do{
            
            
            let rows = try DataBase.shared.sqlHelper.select(table: "Expenses", columns: ["title","amount","category","id","note","createdDate"])
            expenses.removeAll()
            for row in rows {
                var expense: (amount: Double, category: String,title : String,date : Date,note: String,id : String)
                expense.title = row["title"] as! String
                expense.category = row["category"] as! String
                expense.amount = row["amount"] as! Double
                expense.id = row["id"] as! String
                expense.note = row["note"] as! String
                expense.date = Date(timeIntervalSince1970: row["createdDate"] as! Double)
                expenses.append(expense)
            }
            table.reloadData()
            
        }catch let error as SQLiteError{
            switch error{
            case SQLiteError.sqliteError(message: let msg):
                print(msg)
            }

        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    @objc func plusBtnTapped(){
        
        let  addExpenseVC = AddExpenseVC()
        let presenter = AddExpensePresenter()
        presenter.view = addExpenseVC
        addExpenseVC.presenter = presenter
        
        navigationController?.pushViewController(addExpenseVC, animated: true)
    }
    
}















extension RecordsVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
        cell.textLabel?.text = String(expenses[indexPath.row].amount)
        cell.detailTextLabel?.text = expenses[indexPath.row].category
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let expense = expenses[indexPath.row]
        var attachments = [Data]()
        do{
            let rows = try DataBase.shared.sqlHelper.select(table: "Attachments", columns: ["id","url"],whereClause: "expenseId = '\(expense.id)'")
            let attchmentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            for row in rows {
                let url = row["url"] as! String
                let restoredUrl = attchmentsDir.appendingPathComponent(url)
                print("url restored")
                print(restoredUrl)
                if let data = try? Data(contentsOf: restoredUrl){
                    print("got data from the image url")
                    attachments.append(data)
                }
            }
            
        }catch let error as SQLiteError{
            switch error{
            case SQLiteError.sqliteError(message: let msg):
                print(msg)
            }

        }catch{
            print(error.localizedDescription)
        }
        
        
        
        
        
        let  addExpenseVC = AddExpenseVC()
        let presenter = AddExpensePresenter()
        presenter.expense = Expense(title: expense.title, amount: expense.amount, date: expense.date, note: expense.note, category: expense.category, attachments: attachments)
        presenter.view = addExpenseVC
        addExpenseVC.presenter = presenter
        
        navigationController?.pushViewController(addExpenseVC, animated: true)
        
        
        
    }
    
}






































class ExpenseTableViewCell: UITableViewCell{
    
    
    
   
    
    
    
    
    
}




