//
//  AnalysisVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 02/03/23.
//

import UIKit











class AnalysisVC: UIViewController {
    
    var presenter: AnalysisPresenterProctocol?

    private lazy var table = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.bounces = true
        table.register(PieChartCell.self, forCellReuseIdentifier: PieChartCell.reuseID)
        table.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
        table.register(MoneySpentCell.self, forCellReuseIdentifier: MoneySpentCell.reuseID)
        table.separatorInset = .zero
        return table
    }()
    
    private var pieChartData = [(Double,UIColor,String?)](){
        didSet{
            total = pieChartData.reduce(0.0){$0 + $1.0}
            refreshView()
        }
    }
    
    private var total: Double = 0.0
    private lazy var segmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Day","Week","Month","Year","All"])
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    private lazy var forwardBtn = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(.init(paletteColors: [UIColor.systemTeal])), for: .normal)
        button.addTarget(self, action: #selector(forwardBtnTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.imageView?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    private lazy var backwardBtn = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left")?.applyingSymbolConfiguration(.init(paletteColors: [UIColor.systemTeal])), for: .normal)
        button.addTarget(self, action: #selector(backwardBtnTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.clipsToBounds = true
        
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.imageView?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    
    let dateStack = UIStackView()
    
    let stack = UIStackView()
    
    
    @objc func forwardBtnTapped(){
        presenter?.dateNavigatorForwardClicked()
    }
    @objc func backwardBtnTapped(){
        presenter?.dateNavigatorBackWardClicked()
    }
    @objc func segmentedControlValueChanged(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 4 {
            hideDateNavigator()
        }else{
            showDateNavigator()
        }
        presenter?.didChangeDateSegment(dateSegment: TimePeriod(rawValue: segmentedControl.selectedSegmentIndex)!)
    }
    
    
    
    private func showDateNavigator(){
        if dateStack.isHidden {
            
            UIView.animate(withDuration: 0.35) { [unowned self] in
                
                self.dateStack.isHidden = false
                self.dateStack.alpha = 1
                self.stack.layoutIfNeeded()
            }
        }
    }
    
    
    private func hideDateNavigator(){
        if !dateStack.isHidden {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                
                self.dateStack.isHidden = true
                self.dateStack.alpha = 0
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = true
//        view.addSubview(stack)
        view.addSubview(table)
        view.addSubview(stack)
        
//        table.pinToSafeArea(view: view)
        
        
        segmentedControl.selectedSegmentIndex = 2
//        table.tableHeaderView = segmentedControl
        dateStack.translatesAutoresizingMaskIntoConstraints = false
        dateStack.addArrangedSubview(backwardBtn)
        dateStack.addArrangedSubview(dateLabel)
        dateStack.addArrangedSubview(forwardBtn)
        
        dateStack.axis = .horizontal
        dateStack.alignment = .center
        dateStack.distribution = .equalCentering
        dateStack.spacing = 10
        
        dateStack.isLayoutMarginsRelativeArrangement = true
        dateStack.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        
        stack.addArrangedSubview(segmentedControl)
        stack.addArrangedSubview(dateStack)
        
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackTopConstraint = stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5)
        let stackBottomConstraint = stack.bottomAnchor.constraint(equalTo: table.topAnchor,constant: -5)
        
//        table.contentInset = .init(top: 400, left: 0, bottom: 0, right: 0)
//        stackBottomConstraint.priority = UILayoutPriority(800)
        NSLayoutConstraint.activate([
            stackTopConstraint,
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -15),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 15),
            stackBottomConstraint,
            
            forwardBtn.heightAnchor.constraint(equalToConstant: 30),
            backwardBtn.heightAnchor.constraint(equalToConstant: 30),
            
             forwardBtn.widthAnchor.constraint(equalToConstant: 30),
            backwardBtn.widthAnchor.constraint(equalToConstant: 30),
            
            
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -5),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 5),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        dateLabel.text = "Monthly Analysis"
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = false
        presenter?.viewWillAppear()
    }
    
    func refreshView(){
//        UIView.transition(with: table, duration: 0.35, options: .transitionCrossDissolve, animations: {self.table.reloadData()}, completion: nil)
        table.reloadData()
    }
    
}





protocol AnalysisPresenterProctocol: AnyObject{
    func viewDidLoad()
    func viewWillAppear()
//    func pieChart() -> [(Double,UIColor,String?)]
    func didChangeDateSegment(dateSegment: TimePeriod)
    func dateNavigatorForwardClicked()
    func dateNavigatorBackWardClicked()
}



extension AnalysisVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 60
        }
        
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pieChartData.count + 1 == 1 ? 0 : pieChartData.count + 1
        return section == 0 ? 1 : pieChartData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = table.dequeueReusableCell(withIdentifier: MoneySpentCell.reuseID, for: indexPath) as! MoneySpentCell
            cell.setTitle("Total Expense")
            cell.setTotal("\u{20B9} \(String((total * 100).rounded() / 100))")
            cell.selectionStyle = .none
            
            return cell
        }else{
            
            if indexPath.row == 0 {
                let cell = table.dequeueReusableCell(withIdentifier: PieChartCell.reuseID, for: indexPath) as! PieChartCell
                cell.pieChartData = pieChartData
                cell.selectionStyle = .none
               
                return cell
            }else{
                let cell = table.dequeueReusableCell(withIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
                cell.selectionStyle = .none
                let data = pieChartData[indexPath.row - 1]
                cell.setTitle(data.2 ?? "")
                cell.setTotal("\u{20B9} \(String(data.0))")
                let percentage = (data.0 * 10000 / total).rounded() / 100
                var percentString = ""
                if percentage == 0.00 && data.0 > 0{
                    percentString = "≈ \(String(percentage)) %"
                }else{
                    percentString = "\(String(percentage)) %"
                }
                cell.setPercentage(percentString)
                cell.setIconColor(colour: data.1)
                return cell
            }
            
        }
        
    }
    
    

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Category wise spending"
        }else{
            return nil
        }
        
    }
    
}



extension AnalysisVC: AnalysisView{
    func updatePieChart(with pieChartData: [(Double, UIColor, String?)]) {
        self.pieChartData = pieChartData
    }
    
    var selectedDateInterval: TimePeriod {
        get {
            TimePeriod(rawValue: segmentedControl.selectedSegmentIndex)!
        }
        set {
            segmentedControl.selectedSegmentIndex = newValue.rawValue
        }
    }
    
    var dateTitle: String {
        get {
            dateLabel.text ?? ""
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    
    
    
}

