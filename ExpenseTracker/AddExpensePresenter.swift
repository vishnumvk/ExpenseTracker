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
    
    var view: AddExpenseView? {get set}
    
}



protocol AddExpenseView: NSObject{
    
    func openCamera()
    func presentCameraSettings()
    func openPhotoLibrary()
    func presentPhotoLibrarySettings()
    func saveToPhotos()
    func showAlert(title: String)
    var title: String?{get set}
    var amount: String?{get set}
    var category: String?{get set}
    var note: String?{get set}
    var date: Date{get set}
    var attachments: [UIImage]{get set}
    
}








class AddExpensePresenter: AddExpensePresenterProtocol{
    
    
    func tappedSave() {
        
        guard let amount = view?.amount else {
            view?.showAlert(title: "Enter amount")
            return
        }
        guard let amount = Double(amount),amount > 0 else{
            view?.showAlert(title: "Enter valid amount")
            return
        }
        guard amount < 100000000 else{
            view?.showAlert(title: "Enter an amount smaller than 1000,00,000")
            return
        }
        guard let category = view?.category,category != "Category" else{
            view?.showAlert(title: "Please select a Category")
            return
        }
        
        db?.save(expense: Expense(title: view?.title, amount: amount, date: view?.date ?? Date(), note: view?.note, category: category, attachments: view?.attachments.compactMap({$0.jpegData(compressionQuality: 1.0)})))
        
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
    var db: ExpenseDBPr?
    
    
    deinit {
        print("presenter deinit called")
    }
    
}





protocol ExpenseDBPr{
    func save(expense: Expense)
}




class ExpenseDB: ExpenseDBPr{
    
    func save(expense: Expense) {
        
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
