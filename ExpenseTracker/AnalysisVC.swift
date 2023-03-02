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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
       
    }
    

    
}
