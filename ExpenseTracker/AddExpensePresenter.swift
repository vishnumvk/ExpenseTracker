//
//  AddExpensePresenter.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 22/02/23.
//

import Foundation
import AVFoundation
import Photos
import UIKit.UIImage


protocol AddExpensePresenterProtocol: AnyObject{
    
    
    func camBtnTapped()
    func clipBtnTapped()
    func optedToSaveCapturedImageToPhotos()
    func tappedSave()
    func viewDidLoad()
    func shouldReplaceTextInAmountField(textPresent: String,range: NSRange,incomingText: String) -> Bool
//    var view: AddExpenseView? {get set}
    
}



protocol AddExpenseView: NSObject{
    
    func openCamera()
    func presentCameraSettings()
    func openPhotoLibrary(selectionLimit: Int)
    func presentPhotoLibrarySettings()
    func saveToPhotos()
    func showAlert(title: String,message: String?)
    func dismissView()
    var expenseTitle: String?{get set}
    var amount: String?{get set}
    var category: String?{get set}
    var note: String?{get set}
    var date: Date{get set}
    var attachments: [Data]{get set}
    var navTitle: String? {get set}
    var expenseID: String? {get set}
    var amountFieldWarning: String? {get set}
    var categoryFieldWarning: String? {get set}
    
}

protocol AddExpensePresenterDelegate: AnyObject{
    
    func expenseDidChange(editedExpense: ExpenseWithAttachmentsData)
    
}






class AddExpensePresenter: AddExpensePresenterProtocol{
    
    var expense: ExpenseWithAttachmentsData?
    
    weak var view: AddExpenseView?
    var db: ExpenseDBPr? = ExpenseDB()
    
    weak var delegate: AddExpensePresenterDelegate?
    
    func viewDidLoad() {
        guard let expense else{
            print("expense not configured")
            view?.navTitle = "Add Expense"
            return
        }
        print("expense configured")
        view?.expenseTitle = expense.title
        view?.amount = String(expense.amount)
        view?.attachments = expense.attachments ?? [Data]()
        view?.category = expense.category
        view?.note = expense.note
        view?.date = expense.date
        view?.navTitle = "Edit Expense"
        view?.expenseID = expense.id
       
    }
    
    
    
    func tappedSave() {
        
        var isValid = true
        
        
        if !validateAmountField(amount: view?.amount ?? ""){
            isValid = false
        }
        
        let category = view?.category ?? "None"
        if category == "None"{
            view?.categoryFieldWarning = "Select a category"
            isValid = false
           
        }
        
        guard let amount = Double(view?.amount ?? "") else{
            return
        }
        
        guard isValid else{
            return
        }
        
        if let id = view?.expenseID{
            let expense = ExpenseWithAttachmentsData(title: view?.expenseTitle, amount: amount, date: view?.date ?? Date(), note: view?.note, category: category, attachments: view?.attachments.compactMap({$0}),id: id)
            db?.update(expense: expense)
            delegate?.expenseDidChange(editedExpense: expense)

        }else{
            db?.save(expense: ExpenseWithAttachmentsData(title: view?.expenseTitle, amount: amount, date: view?.date ?? Date(), note: view?.note, category: category, attachments: view?.attachments.compactMap({$0})))
        }
//        db?.save(expense: ExpenseWithAttachmentsData(title: view?.expenseTitle, amount: amount, date: view?.date ?? Date(), note: view?.note, category: category, attachments: view?.attachments.compactMap({$0})))
        
        view?.dismissView()
    }
    
    func optedToSaveCapturedImageToPhotos() {
                switch PHPhotoLibrary.authorizationStatus(for: .addOnly){
                case .authorized:
                    view?.saveToPhotos()
                case .denied:
                    view?.presentPhotoLibrarySettings()
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
                        switch status{
                        case .authorized:
                            self?.view?.saveToPhotos()
                        default:
                            print("photo library access was denied")
                        }
                    }
                default:
                    print("unhandled authorization status")
                }
    }
    
    
    func shouldReplaceTextInAmountField(textPresent: String, range: NSRange, incomingText: String) -> Bool {
        let amount = (textPresent as NSString).replacingCharacters(in: range, with: incomingText)
        print("--\(amount)--")
        let regex = try! NSRegularExpression(pattern: "^\\d*(\\.\\d{0,2})?$")
        let match = regex.firstMatch(in: amount, range: NSRange(location: 0, length: amount.utf16.count))
        if match != nil{
            let _ = validateAmountField(amount: amount)
            return true
        }
        else{
            return false
        }
        
    }
    
    private func validateAmountField(amount: String) -> Bool{
        
        
        
        guard amount != "" else {
            view?.amountFieldWarning = "Enter amount"
            return false
        }
        print("+\(amount)+")
        guard Double(amount) != nil else{
            view?.amountFieldWarning = "Enter valid amount"
            return false
        }
        guard let amountValue = Double(amount),amountValue > 0 else{
            view?.amountFieldWarning = "Amount cannot be zero"
            return false
        }
        guard amountValue < 100000000 else{
            view?.amountFieldWarning = "Enter an amount smaller than 1000,00,000"
            return false
        }
        
        view?.amountFieldWarning = nil
        return true
    }
    
    
    func clipBtnTapped() {
        
        let selectionLimit = 10 - ((view?.attachments.count) ?? 0)
        
        if selectionLimit > 0{
            view?.openPhotoLibrary(selectionLimit: selectionLimit)
        }else{
            view?.showAlert(title: "Attachments", message: "Cannot add more than 10 attachments in a Expense")
        }
        
        
        

    }
    
    
    
    
    func camBtnTapped() {
        let selectionLimit = 10 - ((view?.attachments.count) ?? 0)
        
        guard selectionLimit > 0 else{
            view?.showAlert(title: "Attachments", message: "Cannot add more than 10 attachments in a Expense")
            return
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            view?.presentCameraSettings()
        case .restricted:
            print("access is restricted")
        case .authorized:
            view?.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [self] success in
                if success {
                    view?.openCamera()
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            print("Unknown case")
        }
        
    }
        
        
        

    
    deinit {
        print("presenter deinit called")
    }
    
}





protocol ExpenseDBPr{
    func save(expense: ExpenseWithAttachmentsData)
    func update(expense: ExpenseWithAttachmentsData)
}














class ExpenseDB: ExpenseDBPr{
    func update(expense: ExpenseWithAttachmentsData) {
        
        var imageUrls = [String]()
        
        let attchmentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let attchmentsDir = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//
        deleteExpense(expense: expense)
        if let attachments = expense.attachments{
            for data in attachments{
                let url = URL(filePath: "\(expense.date) \(expense.attachments?.firstIndex(of: data) ?? 1)", directoryHint: .inferFromPath, relativeTo: attchmentsDir).appendingPathExtension("jpeg")
                do{
                    try data.write(to: url)
                    imageUrls.append(url.path(percentEncoded: false))
                    print(url.path())
                    
                }catch{
                    print("error while saving attachments")
                }
            }
        }
        
        do{
            
            try DataBase.shared.sqlHelper.update(table: "\(ExpensesTable.name)", values: [
                "\(ExpensesTable.title)" : expense.title,
                "\(ExpensesTable.amount)" : expense.amount,
//                "\(ExpensesTable.id)" : id,
                "\(ExpensesTable.category)" : expense.category,
                "\(ExpensesTable.note)" : expense.note,
                "\(ExpensesTable.date)" : expense.date.timeIntervalSince1970
            ], whereClause: "\(ExpensesTable.id) = '\(expense.id!)'")
           
            for imageUrl in imageUrls {
                try DataBase.shared.sqlHelper.insert(table: "\(AttachmentsTable.name)", values: [
                    "\(AttachmentsTable.url)" : imageUrl,
                    "\(AttachmentsTable.expenseId)" : expense.id
                ])
            }
            
            
            
        }catch let error as SQLiteError{
            switch error{
            case SQLiteError.sqliteError(message: let msg):
                print(msg)
                print("error while updating")
            }

        }catch{
            print(error.localizedDescription)
        }

    }
    
    
    func save(expense: ExpenseWithAttachmentsData) {
        
        var imageUrls = [String]()
        
        let attchmentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let attchmentsDir = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//
        if let attachments = expense.attachments{
            for data in attachments{
                let url = URL(filePath: "\(expense.date) \(expense.attachments?.firstIndex(of: data) ?? 1)", directoryHint: .inferFromPath, relativeTo: attchmentsDir).appendingPathExtension("jpeg")
                do{
                    try data.write(to: url)
                    imageUrls.append(url.path(percentEncoded: false))
                    print(url.path())
                    
                }catch{
                    print("error while saving attachments")
                }
            }
        }
        
        do{
            let id = UUID().uuidString
            try DataBase.shared.sqlHelper.insert(table: "\(ExpensesTable.name)", values: [
                "\(ExpensesTable.title)" : expense.title,
                "\(ExpensesTable.amount)" : expense.amount,
                "\(ExpensesTable.id)" : id,
                "\(ExpensesTable.category)" : expense.category,
                "\(ExpensesTable.note)" : expense.note,
                "\(ExpensesTable.date)" : expense.date.timeIntervalSince1970
            ])
           
            for imageUrl in imageUrls {
                try DataBase.shared.sqlHelper.insert(table: "\(AttachmentsTable.name)", values: [
                    "\(AttachmentsTable.url)" : imageUrl,
                    "\(AttachmentsTable.expenseId)" : id
                ])
            }
            
            
            
        }catch let error as SQLiteError{
            switch error{
            case SQLiteError.sqliteError(message: let msg):
                print(msg)
                print("error while saving")
            }

        }catch{
            print(error.localizedDescription)
        }

        
    }
    
    func deleteExpense(expense: ExpenseWithAttachmentsData){
        do{
            guard let deletedExpenseID = expense.id else{
                return
            }
            let imageUrls = try? DataBase.shared.sqlHelper.select(table: AttachmentsTable.name, columns: [AttachmentsTable.url],whereClause: "\(AttachmentsTable.expenseId) = '\(deletedExpenseID)'").map{$0[AttachmentsTable.url] as! String}
            
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
            
            try DataBase.shared.sqlHelper.delete(from: AttachmentsTable.name, whereClause: "\(AttachmentsTable.expenseId) = '\(deletedExpenseID)'")
           
            
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















struct Expense{
    var id: String
    var title: String?
    var amount: Double
    var date: Date
    var note: String?
    var category: String
    var attachments: [URL]?
    
    
    
}

struct ExpenseWithAttachmentsData{
    
    var title: String?
    var amount: Double
    var date: Date
    var note: String?
    var category: String
    var attachments: [Data]?
    var id: String?
    
    
}
