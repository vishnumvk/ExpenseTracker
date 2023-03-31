//
//  ExpenseDetailPresenter.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 24/03/23.
//

import Foundation

enum ExpenseDetailFieldKey: String{
    case amount
    case title
    case category
    case date
    case note
    case attachments
}

protocol ExpenseDetailView: AnyObject{
    
    var fields: [FormField] {get set}
    func showEditScreen(for expense: ExpenseWithAttachmentsData)
    
}


class ExpenseDetailPresenter: ExpenseDetailPresenterProtocol{
    
    init(expense: ExpenseWithAttachmentsData) {
        self.expense = expense
        
    }
    
    
    
    
    func viewDidLoad() {
        updateFields()
    }
    
    func editTapped() {
        view?.showEditScreen(for: expense)
    }
    
    
    private func updateFields(){
        
        var fields = [FormField]()
        
        if let title = expense.title{
            fields.append(DetailField(key: ExpenseDetailFieldKey.title.rawValue, data: .init(fieldTitle: "Title", fieldValue: title )))
        }
    
        fields.append(DetailField(key: ExpenseDetailFieldKey.amount.rawValue, data: .init(fieldTitle: "Amount", fieldValue: String(expense.amount) )))
        
        fields.append(DetailField(key: ExpenseDetailFieldKey.category.rawValue, data: .init(fieldTitle: "Category", fieldValue: String(expense.category) )))
        
        fields.append(DetailField(key: ExpenseDetailFieldKey.date.rawValue, data: .init(fieldTitle: "Date", fieldValue: expense.date.formatted(date: .abbreviated, time: .shortened))))
        
        
        if let note = expense.note{
            fields.append(DetailField(key: ExpenseDetailFieldKey.note.rawValue, data: .init(fieldTitle: "Note", fieldValue: note )))
        }
        
        if let attachments = expense.attachments{
//            let attachmentsData = attachments.compactMap{try? Data(contentsOf: $0)}
            if attachments.count != 0{
                fields.append(AttachmentsField(key: ExpenseDetailFieldKey.attachments.rawValue, data: .init(fieldTitle: "Attachments  (\(attachments.count))", data: attachments)))
            }
        }
        view?.fields = fields
    }
    
    
    var expense: ExpenseWithAttachmentsData{
        didSet{
            updateFields()
        }
    }
    weak var view: ExpenseDetailView?
    
}


extension ExpenseDetailPresenter: AddExpensePresenterDelegate{
    func expenseDidChange(editedExpense: ExpenseWithAttachmentsData) {
        expense = editedExpense
    }
    
    
}
