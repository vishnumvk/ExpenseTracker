//
//  AnalysisPresenter.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 16/03/23.
//

import Foundation
import UIKit.UIColor

enum TimePeriod:Int{
    case day,week,month,year,overAll
}

protocol AnalysisView: NSObject{
    
    func updatePieChart(with pieChartData: [(Double, UIColor, String?)])
    var selectedDateInterval: TimePeriod {get set}
    var dateTitle: String {get set}
}


class AnalysisPresenter: AnalysisPresenterProctocol{
    
    
    
    weak var view: AnalysisView?
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        updateData()
    }
    
    func pieChart() -> [(Double, UIColor, String?)] {
        return getPieChartData()
    }
    
    
    
    
    
    
    
    
    func didChangeDateSegment(dateSegment: TimePeriod) {
        referenceDate = Date()
        selectedTimePeriod = dateSegment
        updateData()
    }
    
    func dateNavigatorForwardClicked() {
        view?.dateTitle = "forward"
        updateReferenceDate(value: 1)
        updateData()
    }
    
    func dateNavigatorBackWardClicked() {
        view?.dateTitle = "backward"
        updateReferenceDate(value: -1)
        updateData()
    }
    
    
    
    
    
    private func updateReferenceDate(value: Int){
        
        switch selectedTimePeriod{
        case .day:
            referenceDate = calendar.date(byAdding: .day, value: value, to: referenceDate)!
            
        case .week:
            referenceDate = calendar.date(byAdding: .weekOfYear, value: value, to: referenceDate)!
        case .month:
            referenceDate = calendar.date(byAdding: .month, value: value, to: referenceDate)!
        case .year:
            referenceDate = calendar.date(byAdding: .year, value: value, to: referenceDate)!
        case .overAll:
            return
            
        }
        
    }
    
    
    
    
    private func updateData(){
        
        
        updateUI()
        let interval = getTimePeriodStartAndEndMillisSince1970()
        let data = getPieChartData(fromDateInmillsSince1970: interval?.start, toDateInmillsSince1970: interval?.end)
        print(interval ?? "no interval")
        
        view?.updatePieChart(with: data)
    }
   
    
    
   
    private var selectedTimePeriod: TimePeriod = .month
    
    private var startMills: Double = Date().timeIntervalSince1970
    private var endMills: Double = Date().timeIntervalSince1970
    let calendar = Calendar.current
    private var referenceDate = Date()
    
    func getTimePeriodStartAndEndMillisSince1970() -> (start: Double, end: Double)? {
        
        var startOfDay: Date
        var endOfDay: Date
    
        switch selectedTimePeriod {
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
    
    
    
    func updateUI() {
        let formatter = DateFormatter()
        
        switch selectedTimePeriod {
        case .day:
            formatter.dateFormat = "EEEE, d MMMM yyyy"
            let dateString = formatter.string(from: referenceDate)
            view?.dateTitle = dateString
            
        case .week:
            
            formatter.dateFormat = "dd/MMM/yyyy"
            let interval = calendar.intervalOfWeek(for: referenceDate)!
            let startDateString = formatter.string(from: interval.start)
            let endDateString = formatter.string(from: interval.end.addingTimeInterval(-1))
            
            view?.dateTitle = "\(startDateString)  -  \(endDateString)"
            
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            let dateString = formatter.string(from: referenceDate)
            view?.dateTitle = dateString
            
        case .year:
            formatter.dateFormat = "yyyy"
            let dateString = formatter.string(from: referenceDate)
            view?.dateTitle = dateString
        case .overAll:
            print("no label")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    private func getPieChartData(fromDateInmillsSince1970: Double? = nil,toDateInmillsSince1970: Double? = nil) -> [(Double, UIColor, String?)]{
        
        
        var query = "SELECT \(ExpensesTable.category),SUM(\(ExpensesTable.amount)) FROM \(ExpensesTable.name) GROUP BY \(ExpensesTable.category) ORDER BY SUM(\(ExpensesTable.amount)) DESC"
        
        if let fromDateInmillsSince1970, let toDateInmillsSince1970{
            query = "SELECT \(ExpensesTable.category),SUM(\(ExpensesTable.amount)) FROM \(ExpensesTable.name) WHERE \(ExpensesTable.date) BETWEEN \(fromDateInmillsSince1970) AND \(toDateInmillsSince1970) GROUP BY \(ExpensesTable.category) ORDER BY SUM(\(ExpensesTable.amount)) DESC"
        }
        
        var pieChartData =  [(Double, UIColor, String?)]()
        let colours: [UIColor] = [.systemRed,.systemCyan,.systemMint,.systemBlue,.systemPurple,.systemBrown,.systemYellow,.systemOrange,.systemPurple,.systemPink,.systemGreen,.systemIndigo]
        
        do{
            let results = try DataBase.shared.sqlHelper.executeSelect(query: query)
           
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




