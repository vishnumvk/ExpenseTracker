//
//  TabBarVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 16/03/23.
//

import UIKit

class MainTabBarController: UITabBarController {

    
    
    override func viewDidLoad() {
        
        
        tabBar.backgroundColor = .secondarySystemBackground
        tabBar.tintColor = .systemTeal
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .systemGray3
        
        let recordsVC = RecordsVC()
        let recordsPresenter = RecordsPresenter()
        recordsPresenter.view = recordsVC
        recordsVC.presenter = recordsPresenter
        
        
        let analysisVC = AnalysisVC()
        
        recordsVC.tabBarItem.image = UIImage(systemName: "list.clipboard")
        recordsVC.title = "Records"
        analysisVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill")
        analysisVC.title = "Analysis"
        
        
        
        setViewControllers([UINavigationController(rootViewController: recordsVC),UINavigationController(rootViewController: analysisVC)], animated: true)
        
        
    }

}

