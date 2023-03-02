//
//  AnalysisVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 02/03/23.
//

import UIKit


class MainTabBarController: UITabBarController {

    
    
    override func viewDidLoad() {
        
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemTeal
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .systemGray3
        
        let recordVC = RecordsVC()
        let analysisVC = AnalysisVC()
        
        recordVC.tabBarItem.image = UIImage(systemName: "photo.stack.fill")
        recordVC.title = "Records"
        analysisVC.tabBarItem.image = UIImage(systemName: "square.and.arrow.down.on.square")
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
        chart.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.5).isActive = true
        chart.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.5).isActive = true

        
        

        chart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true



        chart.dataSet = [(0.10,.systemYellow),(0.20,.systemPink),(0.30,.systemMint),(0.40,.systemCyan)]



        chart.radius = 150

    }
    

    
}
