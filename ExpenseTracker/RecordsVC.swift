//
//  RecordsVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 07/02/23.
//

import UIKit

import UIKit

class RecordsVC: UIViewController {

    private var dateComponent = Calendar.Component.day
    
    
    lazy var datePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        
        return picker
    }()
    lazy var forwardButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        btn.contentVerticalAlignment = .fill
//        btn.contentHorizontalAlignment = .fill
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    lazy var backwardButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        btn.contentVerticalAlignment = .fill
//        btn.contentHorizontalAlignment = .fill
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return btn
    }()
    lazy var filterButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        btn.contentVerticalAlignment = .fill
//        btn.contentHorizontalAlignment = .fill
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        return btn
    }()
    
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .systemCyan
        
        configView()
    }
    
    
    func configView(){
        
        view.addSubview(datePicker)
        view.addSubview(forwardButton)
        view.addSubview(backwardButton)
        view.addSubview(filterButton)
        
        
        let stack = UIStackView(arrangedSubviews: [backwardButton,datePicker,forwardButton,filterButton])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        stack.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalToConstant: 50),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
    }
    
    
    

    @objc func forwardButtonTapped() {
        datePicker.date = Calendar.current.date(byAdding: dateComponent, value: 1, to: datePicker.date)!
    }

    @objc func backwardButtonTapped() {
        datePicker.date = Calendar.current.date(byAdding: dateComponent, value: -1, to: datePicker.date)!
    }

    
    @objc func filterButtonTapped() {
        let alert = UIAlertController(title: "Select Option", message: nil, preferredStyle: .alert)
        alert.view.backgroundColor = .systemTeal
        let dayAction = UIAlertAction(title: "Day", style: .default) { (action) in
            self.dateComponent = .day
        }
        let weekAction = UIAlertAction(title: "Week", style: .default) { (action) in
            self.dateComponent = .weekOfYear
        }
        let monthAction = UIAlertAction(title: "Month", style: .default) { (action) in
            self.dateComponent = .month
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dayAction)
        alert.addAction(weekAction)
        alert.addAction(monthAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
