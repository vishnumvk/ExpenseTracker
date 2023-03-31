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
    func sortByAmount()
    func sortByCreatedDate()
    func didChangeFilter(filterClue: RecordsFilterClue)
    func updateSearchResults(for searchClue: String)
}


protocol RecordsView: NSObject{
    func showNoRecordsView()
    func hideNoRecordsView()
    func showExpense(expense: ExpenseWithAttachmentsData)
    func refreshView()
    var sortClue: RecordsSortClue {get}
    var filterClue: RecordsFilterClue {get}
    var contextTitle: String? {get set}
    
}

enum RecordsSortClue: Int{
    case sortByAmount
    case sortByCreatedDate
    func callAsFunction() -> Int { rawValue }
}

enum RecordsFilterClue: Int{
    
    case today
    case thisWeek
    case thisMonth
    case thisYear
    case all
    
}


class RecordsPresenter: RecordsPresenterProtocol{
    
    
    func updateSearchResults(for searchClue: String) {
        guard searchClue != "" else{
            return
        }
        loadExpenses()
        expenses = expenses.filter { expense in
            if let title = expense.title{
                return title.lowercased().contains(searchClue.lowercased())
            }else{
                return false
            }
        }
        view?.refreshView()
        configureView()
    }
    
    
    
    func didChangeFilter(filterClue: RecordsFilterClue) {
        loadExpenses()
        view?.refreshView()
        switch filterClue{
            
        case .today:
            view?.contextTitle = "Today"
        case .thisWeek:
            view?.contextTitle = "This Week"
        case .thisMonth:
            view?.contextTitle = "This Month"
        case .thisYear:
            view?.contextTitle = "This Year"
        case .all:
            view?.contextTitle = "All"
        }
    }
    
    func sortByCreatedDate() {
        expenses = expenses.sorted{$0.date > $1.date}
        view?.refreshView()
    }
    
    func sortByAmount() {
        expenses = expenses.sorted{$0.amount > $1.amount}
        view?.refreshView()
    }
    
    
    
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
            let rows = try DataBase.shared.sqlHelper.select(table: "\(AttachmentsTable.name)", columns: ["\(AttachmentsTable.id)","\(AttachmentsTable.url)"],whereClause: "\(AttachmentsTable.expenseId) = '\(expense.id)'")
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
        view?.showExpense(expense: ExpenseWithAttachmentsData(title: expense.title, amount: expense.amount, date: expense.date, note: expense.note, category: expense.category, attachments: attachments, id: expense.id))
    }

    
    func dataForCellAt(indexPath: IndexPath) -> RecordsTableCellData {
        let expense = expenses[indexPath.row]
        
        let title = expense.title ?? "-"
        let rupee = "\u{20B9}"
        let amount = "\(rupee) \(String(expense.amount))"
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
            
            var query = "SELECT \(ExpensesTable.title),\(ExpensesTable.amount),\(ExpensesTable.category),\(ExpensesTable.id),\(ExpensesTable.note),\(ExpensesTable.date) FROM \(ExpensesTable.name)"
            var interval: (start: Double, end: Double)? = nil
            
            switch(view?.filterClue){
            case .today:
                interval = getTimePeriodStartAndEndMillisSince1970(timePeriod: .day)
            case .thisWeek:
                interval = getTimePeriodStartAndEndMillisSince1970(timePeriod: .week)
            case .thisMonth:
                interval = getTimePeriodStartAndEndMillisSince1970(timePeriod: .month)
            case .thisYear:
                interval = getTimePeriodStartAndEndMillisSince1970(timePeriod: .year)
            default:
                interval = getTimePeriodStartAndEndMillisSince1970(timePeriod: .overAll)
                
                
            }
            
            if let interval{
                query = "SELECT \(ExpensesTable.title),\(ExpensesTable.amount),\(ExpensesTable.category),\(ExpensesTable.id),\(ExpensesTable.note),\(ExpensesTable.date) FROM \(ExpensesTable.name) WHERE \(ExpensesTable.date) >= \(interval.start) AND \(ExpensesTable.date) < \(interval.end)"
            }
            
            
            let rows = try DataBase.shared.sqlHelper.executeSelect(query: query)
            
            
            expenses.removeAll()
            for row in rows {
                
                let title = row["\(ExpensesTable.title)"] as! String?
                let category = row["\(ExpensesTable.category)"] as! String
                let amount = row["\(ExpensesTable.amount)"] as! Double
                let id = row["\(ExpensesTable.id)"] as! String
                let note = row["\(ExpensesTable.note)"] as! String?
                let date = Date(timeIntervalSince1970: row["\(ExpensesTable.date)"] as! Double)
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
        
        switch (view?.sortClue){
        case .sortByCreatedDate:
            sortByCreatedDate()
        case .sortByAmount:
            sortByAmount()
        case .none:
            sortByCreatedDate()
            
        }
        
        configureView()
        
    }
    
    func configureView(){
        if expenses.count == 0 {
            view?.showNoRecordsView()
        }else{
            view?.hideNoRecordsView()
        }
    }
    
    
    
    
    func getTimePeriodStartAndEndMillisSince1970(timePeriod: TimePeriod) -> (start: Double, end: Double)? {
        
        var startOfDay: Date
        var endOfDay: Date
        let referenceDate = Date()
        let calendar = Calendar.current
        switch timePeriod {
        case .day:
            startOfDay = calendar.startOfDay(for: referenceDate)
            endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: referenceDate))!
            startOfDay = calendar.startOfDay(for: startOfWeek)
            endOfDay = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfDay)!
        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: referenceDate))!
            startOfDay = calendar.startOfDay(for: startOfMonth)
            endOfDay = calendar.date(byAdding: .month, value: 1, to: startOfDay)!
        case .year:
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: referenceDate))!
            startOfDay = calendar.startOfDay(for: startOfYear)
            endOfDay = calendar.date(byAdding: .year, value: 1, to: startOfDay)!
        case .overAll:
            return nil
        }
    
        let startMillis = startOfDay.timeIntervalSince1970
        let endMillis = endOfDay.timeIntervalSince1970
        return (startMillis, endMillis)
    }
    
    
    
    
}
