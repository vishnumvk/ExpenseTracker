//
//  AnalysisPresenter.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 16/03/23.
//

import Foundation
import UIKit.UIColor

enum DateSegment:Int{
    case day,week,month,year,overAll
}

protocol AnalysisView: NSObject{
    
    func updatePieChart(with pieChartData: [(Double, UIColor, String?)])
    var selectedDateInterval: DateSegment {get set}
    var dateTitle: String {get set}
}


class AnalysisPresenter: AnalysisPresenterProctocol{
    
    
    func didChangeDateSegment(dateSegment: DateSegment) {
        print(#function)
    }
    
    func dateNavigatorForwardClicked() {
        print(#function)
    }
    
    func dateNavigatorBackWardClicked() {
        print(#function)
    }
    
    
    weak var view: AnalysisView?
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        view?.updatePieChart(with: getPieChartData())
    }
    
    func pieChart() -> [(Double, UIColor, String?)] {
        return getPieChartData()
    }
    
    private func getPieChartData(startDateInmillsSince1970: Double? = nil,toDateInmillsSince1970: Double? = nil) -> [(Double, UIColor, String?)]{
        var pieChartData =  [(Double, UIColor, String?)]()
        let colours: [UIColor] = [.systemRed,.systemCyan,.systemMint,.systemBlue,.systemPink,.systemBrown,.systemYellow,.systemOrange,.systemPurple,.systemGreen,.systemIndigo]
        
        do{
            let results = try DataBase.shared.sqlHelper.executeSelect(query: "SELECT \(ExpensesTable.category),SUM(\(ExpensesTable.amount)) FROM \(ExpensesTable.name) GROUP BY \(ExpensesTable.category) ORDER BY SUM(\(ExpensesTable.amount)) DESC")
           
            var x = 0
            print(results)
            for result in results {
                
                pieChartData.append((result["SUM(\(ExpensesTable.amount))"] as! Double, colours[x], result[ExpensesTable.category] as? String ))
                
               x = x == colours.count - 1 ?  0 : x+1
            }
            
//            chart.dataSet = pieChartData
        }catch let error as SQLiteError{
            switch error{
            case SQLiteError.sqliteError(message: let msg):
                print(msg)
            }
            
        }catch{
            print(error.localizedDescription)
        }
        return pieChartData
    }
    
}
