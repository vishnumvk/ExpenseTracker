//
//  RecordsPresenter.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 14/03/23.
//

import Foundation


protocol RecordsPresenterProtocol: AnyObject{
    
    func noOfRecords() -> Int
    func dataForCellAt(indexPath: IndexPath) -> RecordsTableCellData
    func loadExpenses()
    func didSelectCellAt(indexPath: IndexPath,cellData: RecordsTableCellData)
    func deleteCellAt(indexPath: IndexPath)
}


protocol RecordsView: NSObject{
    func showNoRecordsView()
    func hideNoRecordsView()
    func showExpense(expense: Expense)
    func refreshView()
}


class RecordsPresenter: RecordsPresenterProtocol{
    
    func deleteCellAt(indexPath: IndexPath) {
        let deletedExpense = expenses.remove(at: indexPath.row)
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
            
            try DataBase.shared.sqlHelper.delete(from: AttachmentsTable.name, whereClause: "\(AttachmentsTable.expenseId) = '\(deletedExpense.id)'")
            try DataBase.shared.sqlHelper.delete(from: ExpensesTable.name, whereClause: "\(ExpensesTable.id) = '\(deletedExpense.id)'")
            
        }catch let error as SQLiteError{
            
            switch error{
            case SQLiteError.sqliteError(message: let msg):
                print(msg)
            }
            
        }catch{
            print(error.localizedDescription)
        }
        view?.refreshView()
        configureView()
    }

    
    func didSelectCellAt(indexPath: IndexPath, cellData: RecordsTableCellData) {
        var expense = expenses[indexPath.row]
        var attachments = [Data]()
        var attachmentURLs = [URL]()
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
                    attachmentURLs.append(restoredUrl)
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
        expense.attachments = attachmentURLs
        view?.showExpense(expense: expense)
    }

    
    func dataForCellAt(indexPath: IndexPath) -> RecordsTableCellData {
        let expense = expenses[indexPath.row]
        
        let title = expense.title
        let amount = String(expense.amount)
        let category = expense.category
        let date = expense.date.formatted(date: .abbreviated, time: .shortened)
        return RecordsTableCellData(id: expense.id, amount: amount, title: title, category: category, date: date)
    }
    
    func noOfRecords() -> Int {
        expenses.count
    }
    
    
    var expenses = [Expense]()
    weak var view: RecordsView?
    
    func loadExpenses(){
        
        do{
            
            
            let rows = try DataBase.shared.sqlHelper.select(table: ExpensesTable.name, columns: ["title","amount","category","id","note","createdDate"])
            expenses.removeAll()
            for row in rows {
                
                let title = row["title"] as! String
                let category = row["category"] as! String
                let amount = row["amount"] as! Double
                let id = row["id"] as! String
                let note = row["note"] as! String
                let date = Date(timeIntervalSince1970: row["createdDate"] as! Double)
                expenses.append(Expense(id: id,title: title, amount: amount, date: date, note: note, category: category, attachments: nil))
            }
            
            
        }catch let error as SQLiteError{
            switch error{
            case SQLiteError.sqliteError(message: let msg):
                print(msg)
            }

        }catch{
            print(error.localizedDescription)
        }
        expenses = expenses.sorted { $0.date > $1.date}
        
        configureView()
        
    }
    func configureView(){
        if expenses.count == 0 {
            view?.showNoRecordsView()
        }else{
            view?.hideNoRecordsView()
        }
    }
    
}
