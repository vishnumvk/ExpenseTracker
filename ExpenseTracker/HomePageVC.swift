//
//  HomePageVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 27/01/23.
//

import UIKit
import Charts

class HomePageVC: UIViewController {
    
    lazy var pieChart = {
        let pieChart = PieChartView()
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        return pieChart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .white
        view.addSubview(pieChart)
        pieChart.pinTo(view: view)
        pieChart.delegate = self
        let set = PieChartDataSet(entries: [
            PieChartDataEntry(value: 100, label: "apples"),
            PieChartDataEntry(value: 200, label: "pine apples"),
            PieChartDataEntry(value: 500, label: "bananas"),
            PieChartDataEntry(value: 100, label: "grapes"),
            PieChartDataEntry(value: 200, label: "mango"),
            PieChartDataEntry(value: 500, label: "jack fruit"),
            PieChartDataEntry(value: 100, label: "custard apples"),
            PieChartDataEntry(value: 200, label: "oranges"),
            PieChartDataEntry(value: 500, label: "pomogranate"),
            PieChartDataEntry(value: 100, label: "guava"),
            PieChartDataEntry(value: 200, label: "star apples"),
            PieChartDataEntry(value: 500, label: "water melons")
            
        ])
        set.colors = ChartColorTemplates.colorful()
        pieChart.data = PieChartData(dataSet: set)
    }
    

   

}

extension HomePageVC: ChartViewDelegate{
    
}
