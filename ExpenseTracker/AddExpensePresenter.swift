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
    var view: AddExpenseView? {get set}
    
}



protocol AddExpenseView: NSObject{
    
    func openCamera()
    func presentCameraSettings()
    func openPhotoLibrary()
    func presentPhotoLibrarySettings()
    func saveToPhotos()
    func showAlert(title: String,message: String?)
    func dismissView()
    var expenseTitle: String?{get set}
    var amount: String?{get set}
    var category: String?{get set}
    var note: String?{get set}
    var date: Date{get set}
    var attachments: [UIImage]{get set}
    
}








class AddExpensePresenter: AddExpensePresenterProtocol{
    
    var expense: Expense?
    
    
    func viewDidLoad() {
        guard let expense else{
            print("expense not configured")
            return
        }
        print("expense configured")
        view?.expenseTitle = expense.title
        view?.amount = String(expense.amount)
        view?.attachments = expense.attachments?.compactMap{UIImage(data: $0)} ?? [UIImage]()
//        view?.attachments = (expense.attachments?.compactMap({ data in
//            if let image = UIImage(data: data){
//                print("image was obtained")
//                return image
//            }else{
//                print("could not obtain image")
//            }
//            return nil
//        }))!
        view?.category = expense.category
        view?.note = expense.note
        view?.date = expense.date
        
    }
    
    
    
    func tappedSave() {
        
        guard let amount = view?.amount else {
            view?.showAlert(title: "Enter amount", message: nil)
            return
        }
        guard let amount = Double(amount),amount > 0 else{
            view?.showAlert(title: "Enter valid amount", message: nil)
            return
        }
        guard amount < 100000000 else{
            view?.showAlert(title: "Enter an amount smaller than 1000,00,000", message: nil)
            return
        }
        guard let category = view?.category,category != "Category" else{
            view?.showAlert(title: "Please select a Category", message: nil)
            return
        }
        
        db?.save(expense: Expense(title: view?.expenseTitle, amount: amount, date: view?.date ?? Date(), note: view?.note, category: category, attachments: view?.attachments.compactMap({$0.jpegData(compressionQuality: 1.0)})))
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
                            self?.view?.openPhotoLibrary()
                        default:
                            print("photo library access was denied")
                        }
                    }
                default:
                    print("unhandled authorization status")
                }
    }
    
    
    
    func clipBtnTapped() {
        
        
        view?.openPhotoLibrary()
        

    }
    
    
    
    
    func camBtnTapped() {
        
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
        
        
        
    
    
    
    
    
    weak var view: AddExpenseView?
    var db: ExpenseDBPr? = ExpenseDB()
    
    
    deinit {
        print("presenter deinit called")
    }
    
}





protocol ExpenseDBPr{
    func save(expense: Expense)
}




class ExpenseDB: ExpenseDBPr{
    
    func save(expense: Expense) {
        
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
            try DataBase.shared.sqlHelper.insert(table: "Expenses", values: [
                "title" : expense.title,
                "amount" : expense.amount,
                "id" : id,
                "category" : expense.category,
                "note" : expense.note,
                "createdDate" : expense.date.timeIntervalSince1970
            ])
            
            for imageUrl in imageUrls {
                try DataBase.shared.sqlHelper.insert(table: "Attachments", values: [
                    "url" : imageUrl,
                    "expenseId" : id
                ])
            }
            
            
            
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
    
    var title: String?
    var amount: Double
    var date: Date
    var note: String?
    var category: String
    var attachments: [Data]?
    
    
    
}
