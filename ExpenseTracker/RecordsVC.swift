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
        button.setImage(UIImage(systemName: "plus.circle.fill")?.applyingSymbolConfiguration(.init(paletteColors: [UIColor.systemTeal])), for: .normal)
        button.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.imageView?.backgroundColor = .systemBackground
        button.imageView?.contentMode = .scaleToFill
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.imageView?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private lazy var table = {
        let table = UITableView(frame: .zero, style: .plain)
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

        table.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.reuseId)
    }
    
    var expenses = [(amount: Double, category: String,title : String,date : Date,note: String, id : String)]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do{
            
            
            let rows = try DataBase.shared.sqlHelper.select(table: ExpensesTable.name, columns: ["title","amount","category","id","note","createdDate"])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.reuseId) as! ExpenseTableViewCell
        let expense = expenses[indexPath.row]
        
        cell.title = expense.title
        cell.amount = String(expense.amount)
        cell.category = expense.category
        cell.date = expense.date.formatted(date: .abbreviated, time: .shortened)
        
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let deletedExpense = expenses.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .fade)
            
            do{
                
                let imageUrls = try? DataBase.shared.sqlHelper.select(table: AttachmentsTable.name, columns: [AttachmentsTable.url],whereClause: "\(AttachmentsTable.expenseId) = '\(deletedExpense.id)'").map{$0[AttachmentsTable.url] as! String}
                
                if let imageUrls{
                    imageUrls.forEach{
                        let url = attachmentsDir.appendingPathComponent($0)
                        if ((try? FileManager.default.removeItem(at: url)) != nil){
                            print("image file deleted successfully")
                        }else{
                            print("error while deleting image file")
                        }
                    }
                }
                
                try DataBase.shared.sqlHelper.delete(from: AttachmentsTable.name, where: "\(AttachmentsTable.expenseId) = '\(deletedExpense.id)'")
                try DataBase.shared.sqlHelper.delete(from: ExpensesTable.name, where: "\(ExpensesTable.id) = '\(deletedExpense.id)'")
                
            }catch let error as SQLiteError{
                
                switch error{
                case SQLiteError.sqliteError(message: let msg):
                    print(msg)
                }
                
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
    
}


























let attachmentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]











class ExpenseTableViewCell: UITableViewCell{
    static let reuseId = "expenseCell"
    
    
    var title: String?{
        get{
            mainTitleLabel.text
        }
        set{
            mainTitleLabel.text = newValue
        }
    }
    
    var date: String?{
        get{
            dateLabel.text
        }
        set{
            dateLabel.text = newValue
        }
    }
    
    var category: String?{
        get{
            categoryLabel.text
        }
        set{
            categoryLabel.text = newValue
        }
    }
    
    var amount: String?{
        get{
            amountLabel.text
        }
        set{
            amountLabel.text = newValue
        }
    }
    
    
    
    
    
    
    private lazy var mainTitleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Untitled"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var categoryLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16,weight: .thin)
        return label
    }()
    
    private lazy var amountLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14,weight: .thin)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        
        
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainTitleLabel.widthAnchor.constraint(equalToConstant: 100),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            amountLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor, constant: 5),

            categoryLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 5),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 5)
        ])
        
        
    }
    
    
    
    
}




