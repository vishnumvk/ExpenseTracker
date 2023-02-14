//
//  RecordsVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 07/02/23.
//

import UIKit







class RecordsVC: UIViewController{
    
    
    private lazy var plusBtn = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.imageView?.contentMode = .scaleToFill
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.imageView?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private lazy var table = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(table)
        view.addSubview(plusBtn)
        table.pinTo(view: view)
        NSLayoutConstraint.activate([
            plusBtn.heightAnchor.constraint(equalToConstant: 60),
            plusBtn.widthAnchor.constraint(equalToConstant: 60),
            plusBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            plusBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ])

       
    }
    
    @objc func plusBtnTapped(){
        print("plus tapped")
        navigationController?.pushViewController(AddExpenseVC(), animated: true)
    }
    
}


extension RecordsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
        cell.textLabel?.text = "Title"
        cell.detailTextLabel?.text = "subtitle"
        return cell
    }
    
    
    
}









































class DateBarController: UIViewController {

    private var dateComponent = Calendar.Component.day
    
    
    lazy var datePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
//        picker.isUserInteractionEnabled = false
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
       
        return picker
    }()
    
    
    lazy var datePicker2 = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    
    
    lazy var forwardButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    lazy var backwardButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return btn
    }()
    lazy var filterButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
//        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        return btn
    }()
    
    lazy var hypen = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "minus")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .gmt
        return cal
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemCyan
        self.datePicker2.isHidden = true
        self.hypen.isHidden = true
        configView()
    }
    
    
    func configView(){
        
        view.addSubview(datePicker)
        view.addSubview(forwardButton)
        view.addSubview(backwardButton)
        view.addSubview(filterButton)
        
        
        let stack = UIStackView(arrangedSubviews: [backwardButton,datePicker,hypen,datePicker2,forwardButton,filterButton])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        stack.backgroundColor = .systemBackground
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 5, left: 20, bottom: 5, right: 10)
        
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalToConstant: 60),
            
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            forwardButton.heightAnchor.constraint(equalToConstant: 25),
            forwardButton.widthAnchor.constraint(equalToConstant: 24),
            filterButton.heightAnchor.constraint(equalToConstant: 20),
            filterButton.widthAnchor.constraint(equalToConstant: 34),
            backwardButton.heightAnchor.constraint(equalTo: forwardButton.heightAnchor),
            backwardButton.widthAnchor.constraint(equalTo: forwardButton.widthAnchor)
        ])
        
    }
    
    
    

    @objc func forwardButtonTapped() {
        let newDate = calendar.date(byAdding: dateComponent, value: 1, to: datePicker.date)!
        datePicker.date =  calendar.startingDate(of: dateComponent, for: newDate)
        datePicker2.date = calendar.endingDate(of: dateComponent, for: newDate)
    }

    @objc func backwardButtonTapped() {
        let newDate = calendar.date(byAdding: dateComponent, value: -1, to: datePicker.date)!
        datePicker.date =  calendar.startingDate(of: dateComponent, for: newDate)
        datePicker2.date = calendar.endingDate(of: dateComponent, for: newDate)
    }

    
    @objc func filterButtonTapped() {
        let alert = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        alert.view.backgroundColor = .systemTeal
        let dayAction = UIAlertAction(title: "Day", style: .default) { (action) in
            self.dateComponent = .day
            self.datePicker2.isHidden = true
            self.hypen.isHidden = true
        }
        let weekAction = UIAlertAction(title: "Week", style: .default) { [self](action) in
            self.dateComponent = .weekOfYear
           
            
            self.datePicker.date = calendar.startOfWeek(for: Date())!
            self.datePicker2.date = calendar.date(byAdding: .day, value: -1, to: calendar.endOfWeek(for: Date())!)!
            self.datePicker2.isHidden = false
            self.hypen.isHidden = false
        }
        let monthAction = UIAlertAction(title: "Month", style: .default) { [self](action) in
            self.dateComponent = .month
            self.datePicker.date = calendar.startOfMonth(for: Date())!
            self.datePicker2.date = calendar.date(byAdding: .day, value: -1, to: calendar.endOfMonth(for: Date())!)!
            self.datePicker2.isHidden = false
            self.hypen.isHidden = false
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dayAction)
        alert.addAction(weekAction)
        alert.addAction(monthAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func dateChanged(sender: UIDatePicker){
        print(sender.date)
        
    }
    
    
    
    
}






extension Calendar {
    
    func intervalOfDay(for date: Date)-> DateInterval?{
       let interval = dateInterval(of: .day, for: date)
        
        return interval
    }
    
    func intervalOfWeek(for date: Date) -> DateInterval? {
        dateInterval(of: .weekOfYear, for: date)
    }
    func startOfWeek(for date: Date) -> Date? {
       let startDate = intervalOfWeek(for: date)?.start
        
        return startDate
    }
    
    func endOfWeek(for date: Date) -> Date? {
        let endDate = intervalOfWeek(for: date)?.end
       
        return endDate
    }
    
    
    
    func intervalOfMonth(for date: Date) -> DateInterval? {
        let interval = dateInterval(of: .month, for: date)
        return interval
    }
    func startOfMonth(for date: Date) -> Date? {
        intervalOfMonth(for: date)?.start
    }
    
    func endOfMonth(for date: Date) -> Date? {
        intervalOfMonth(for: date)?.end
    }
    
    func startingDate(of component: Calendar.Component, for date: Date)-> Date{
        
        let interval = dateInterval(of: component, for: date)
        
        return interval!.start
        
        
        
    }
   
    func endingDate(of component: Calendar.Component, for date: Date)-> Date{
        
        let interval = dateInterval(of: component, for: date)
        
        
        let end = self.date(byAdding: .day, value: -1, to: interval!.end)!
        
        return end
        
        
    }
   
    
}


