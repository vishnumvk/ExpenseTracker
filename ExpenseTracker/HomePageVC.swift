//
//  HomePageVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 27/01/23.
//

import UIKit
//import Charts
//
//class HomePageVC: UIViewController {
//
//    lazy var pieChart = {
//        let pieChart = PieChartView()
//        pieChart.translatesAutoresizingMaskIntoConstraints = false
//
//        return pieChart
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        view.backgroundColor = .white
//        view.addSubview(pieChart)
//        pieChart.pinTo(view: view)
//
//        pieChart.delegate = self
//        let set = PieChartDataSet(entries: [
//            PieChartDataEntry(value: 100, label: "apples"),
//            PieChartDataEntry(value: 200, label: "pine apples"),
//            PieChartDataEntry(value: 500, label: "bananas"),
//            PieChartDataEntry(value: 100, label: "grapes"),
//            PieChartDataEntry(value: 200, label: "mango"),
//            PieChartDataEntry(value: 500, label: "jack fruit"),
//            PieChartDataEntry(value: 100, label: "custard apples"),
//            PieChartDataEntry(value: 200, label: "oranges"),
//            PieChartDataEntry(value: 500, label: "pomogranate"),
//            PieChartDataEntry(value: 100, label: "guava"),
//            PieChartDataEntry(value: 200, label: "star apples"),
//            PieChartDataEntry(value: 500, label: "water melons")
//
//        ])
//        set.colors = ChartColorTemplates.colorful()
//        pieChart.data = PieChartData(dataSet: set)
//
//
//
//
//        let button = UIButton()
//        view.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            button.heightAnchor.constraint(equalToConstant: 60),
//            button.widthAnchor.constraint(equalToConstant: 60),
//            button.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
//            button.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
//        ])
//
//        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
//        button.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
//        button.layer.cornerRadius = 30
//        button.imageView?.contentMode = .scaleToFill
//
//    }
//
//
//    @objc func plusBtnTapped(){
//        print("plus tapped")
//        navigationController?.pushViewController(AddExpenseVC(), animated: true)
//    }
//
//}
//
//
//
//
//
//
//extension HomePageVC: ChartViewDelegate{
//
//}
//









class HomePageVC: UIViewController {

    lazy var pieChart = {
        let pieChart = PieChartView()
        pieChart.translatesAutoresizingMaskIntoConstraints = false
//        pieChart.heightAnchor.constraint(equalToConstant: 500).isActive = true
//        pieChart.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return pieChart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = .white
        view.addSubview(pieChart)
        pieChart.pinTo(view: view)
        pieChart.radius = 150
        pieChart.dataSet = [(100,.systemCyan),(150,.systemMint),(125,.systemPink),(50,.systemBrown),(80,.magenta)]

    }




}

