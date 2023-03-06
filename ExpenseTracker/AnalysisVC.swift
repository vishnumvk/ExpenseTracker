//
//  AnalysisVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 02/03/23.
//

import UIKit


class MainTabBarController: UITabBarController {

    
    
    override func viewDidLoad() {
        
        
        tabBar.backgroundColor = .secondarySystemBackground
        tabBar.tintColor = .systemTeal
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .systemGray3
        
        let recordVC = RecordsVC()
        let analysisVC = AnalysisVC()
        
        recordVC.tabBarItem.image = UIImage(systemName: "list.clipboard")
        recordVC.title = "Records"
        analysisVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill")
        analysisVC.title = "Analysis"
        
        
        
        setViewControllers([UINavigationController(rootViewController: recordVC),analysisVC], animated: true)
        
        
    }

}










class AnalysisVC: UIViewController {

    let chart = PieChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        
       
        

        chart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chart)
        chart.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1).isActive = true
        chart.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1).isActive = true

        
        

        chart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true



        chart.dataSet = [(0.10,.systemYellow,nil),(0.20,.systemPink,nil),(0.30,.systemMint,nil),(0.40,.systemCyan,nil)]



        chart.radius = 120

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let colours: [UIColor] = [.systemTeal,.systemRed,.systemCyan,.systemMint,.systemBlue,.systemPink,.systemBrown,.systemYellow,.systemOrange,.systemPurple,.systemGreen,.systemIndigo]
        
        do{
            let results = try DataBase.shared.sqlHelper.executeSelect(query: "SELECT \(ExpensesTable.category),SUM(\(ExpensesTable.amount)) FROM \(ExpensesTable.name) GROUP BY \(ExpensesTable.category)")
            var pieChartData = [(Double,UIColor,String?)]()
            var x = 0
            print(results)
            for result in results {
                
                pieChartData.append((result["SUM(\(ExpensesTable.amount))"] as! Double, colours[x], result[ExpensesTable.category] as? String ))
                
               x = x == colours.count - 1 ?  0 : x+1
            }
            chart.dataSet = pieChartData
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
