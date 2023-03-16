//
//  Sqlite Tables.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 28/02/23.
//

import Foundation


enum ExpensesTable{
    static let name = "Expenses"
    static let id = "id"
    static let date = "createdDate"
    static let amount = "amount"
    static let category = "category"
    static let title = "title"
    static let note = "note"
}


enum AttachmentsTable{
    static let name = "Attachments"
    static let id = "id"
    static let url = "url"
    static let expenseId = "expenseId"
}
