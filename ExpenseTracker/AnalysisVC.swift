//
//  AnalysisVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 02/03/23.
//

import UIKit











//class AnalysisVC: UIViewController {
//
//    let chart = PieChartView()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//
//
//
//
//
//
//        chart.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(chart)
//        chart.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1).isActive = true
//        chart.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1).isActive = true
//
//
//
//
//        chart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        chart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//
//
//        chart.dataSet = [(0.10,.systemYellow,nil),(0.20,.systemPink,nil),(0.30,.systemMint,nil),(0.40,.systemCyan,nil)]
//
//
//
//        chart.radius = 120
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let colours: [UIColor] = [.systemTeal,.systemRed,.systemCyan,.systemMint,.systemBlue,.systemPink,.systemBrown,.systemYellow,.systemOrange,.systemPurple,.systemGreen,.systemIndigo]
//
//        do{
//            let results = try DataBase.shared.sqlHelper.executeSelect(query: "SELECT \(ExpensesTable.category),SUM(\(ExpensesTable.amount)) FROM \(ExpensesTable.name) GROUP BY \(ExpensesTable.category) ORDER BY SUM(\(ExpensesTable.amount)) ASC")
//            var pieChartData = [(Double,UIColor,String?)]()
//            var x = 0
//            print(results)
//            for result in results {
//
//                pieChartData.append((result["SUM(\(ExpensesTable.amount))"] as! Double, colours[x], result[ExpensesTable.category] as? String ))
//
//               x = x == colours.count - 1 ?  0 : x+1
//            }
//            chart.dataSet = pieChartData
//        }catch let error as SQLiteError{
//            switch error{
//            case SQLiteError.sqliteError(message: let msg):
//                print(msg)
//            }
//
//        }catch{
//            print(error.localizedDescription)
//        }
//
//    }
//
//}

class AnalysisVC: UIViewController {

    private lazy var table = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(PieChartCell.self, forCellReuseIdentifier: PieChartCell.reuseID)
        table.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
        table.separatorInset = .zero
        return table
    }()
    
    var pieChartData = [(Double,UIColor,String?)](){
        didSet{
            total = pieChartData.reduce(0.0){$0 + $1.0}
        }
    }
    
    private var total: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(table)
        
        table.pinToSafeArea(view: view)
        
        let segmentedControl = UISegmentedControl(items: ["Day","Week","Month","Year","All"])
        segmentedControl.selectedSegmentIndex = 2
        table.tableHeaderView = segmentedControl
        
        
        
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pieChartData.removeAll()
        let colours: [UIColor] = [.systemRed,.systemCyan,.systemMint,.systemBlue,.systemPink,.systemBrown,.systemYellow,.systemOrange,.systemPurple,.systemGreen,.systemIndigo]
        
        do{
            let results = try DataBase.shared.sqlHelper.executeSelect(query: "SELECT \(ExpensesTable.category),SUM(\(ExpensesTable.amount)) FROM \(ExpensesTable.name) GROUP BY \(ExpensesTable.category) ORDER BY SUM(\(ExpensesTable.amount)) DESC")
           
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
        table.reloadData()
    }
    
}





extension AnalysisVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pieChartData.count + 1 == 1 ? 0 : pieChartData.count + 1
        return pieChartData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell.setTotal(String(data.0))
            let percentage = (data.0 * 1000 / total).rounded() / 10
            cell.setPercentage("\(String(percentage)) %")
            cell.setIconColor(colour: data.1)
            return cell
        }
        
    }
    
    

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Category wise spending"
        }else{
            return nil
        }
        
    }
    
}



class PieChartCell: UITableViewCell{
    
    static let reuseID = "Pie chart cell"
    
    private lazy var chart = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    private lazy var placeHolder = {
        let placeHolder = PlaceHolderView()
        placeHolder.translatesAutoresizingMaskIntoConstraints = false
        placeHolder.text = "No data !"
        placeHolder.image = UIImage(systemName: "chart.pie.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.placeholderText]))
        return placeHolder
    }()
    
    var pieChartData = [(Double,UIColor,String?)](){
        didSet{
            chart.dataSet = pieChartData
            self.layoutSubviews()
            if pieChartData.count == 0{
                placeHolder.isHidden = false
            }else{
                placeHolder.isHidden = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        
        
        contentView.addSubview(chart)
        contentView.addSubview(placeHolder)
        
        placeHolder.pinToSafeArea(view: contentView)
        
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            chart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            chart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            chart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            chart.heightAnchor.constraint(greaterThanOrEqualToConstant: 350)
              
        ])
        
        chart.radius = 100
        
    }
    
}




class CategoryCell: UITableViewCell{
    
    static let reuseID = "Category cell"
    
    private lazy var iconView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    private lazy var percentLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var totalLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView(){
        
        let stack = UIStackView(arrangedSubviews: [totalLabel,percentLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setContentHuggingPriority(.required, for: .horizontal)
        
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let mainStack = UIStackView(arrangedSubviews: [iconView,titleLabel,stack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = .init(top: 10, left: 15, bottom: 10, right: 15)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        totalLabel.text = "500000.0"
        percentLabel.text = "100 %"
        iconView.backgroundColor = .systemOrange
        titleLabel.text = "Category name"
        
        contentView.addSubview(mainStack)
        mainStack.pinToSafeArea(view: contentView)
        
        
    }
    func setIconColor(colour: UIColor){
        iconView.backgroundColor = colour
    }
    func setTitle(_ title: String){
        titleLabel.text = title
    }
    func setTotal(_ title: String){
        totalLabel.text = title
    }
    func setPercentage(_ title: String){
        percentLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        totalLabel.text = "500000.0"
        percentLabel.text = "100 %"
        iconView.backgroundColor = .systemOrange
        titleLabel.text = "Category name"
    }
}
