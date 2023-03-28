//
//  RecordsVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 07/02/23.
//

import UIKit







class RecordsVC: UIViewController{
    
    var presenter: RecordsPresenterProtocol?
    var filterClue: RecordsFilterClue = .all
    var sortClue: RecordsSortClue = .sortByCreatedDate
    private lazy var plusBtn = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle.fill")?.applyingSymbolConfiguration(.init(paletteColors: [UIColor.systemTeal])), for: .normal)
        button.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.imageView?.backgroundColor = .systemBackground
        button.imageView?.contentMode = .scaleToFill
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.imageView?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private lazy var table = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var noRecordsView = {
        let view = PlaceHolderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "No Records !"
        view.image = UIImage(systemName: "doc.text.magnifyingglass")?.applyingSymbolConfiguration(.init(paletteColors: [.placeholderText]))
        return view
    }()
    
    private var sortMenu: UIMenu?
    private var filterMenu: UIMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(table)
        view.addSubview(plusBtn)
        view.addSubview(noRecordsView)
//        hidesBottomBarWhenPushed = true
        table.pinToSafeArea(view: view)
//        noRecordsView.backgroundColor = .tertiarySystemBackground
        noRecordsView.pinToSafeArea(view: view)
        
        view.bringSubviewToFront(plusBtn)
        NSLayoutConstraint.activate([
            plusBtn.heightAnchor.constraint(equalToConstant: 60),
            plusBtn.widthAnchor.constraint(equalToConstant: 60),
            plusBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            plusBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
//            noRecordsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            noRecordsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])

        table.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.reuseId)
        
        
        let sortByAmount = UIAction(title: "Amount"){ [weak self] _ in
            self?.presenter?.sortByAmount()
            self?.sortClue = .sortByAmount
        }
        
        
        
        let sortByCreatedDate = UIAction(title: "Expense date"){ [weak self] _ in
            self?.presenter?.sortByCreatedDate()
            self?.sortClue = .sortByCreatedDate
        }
        
        sortByCreatedDate.state = .on
        
        sortMenu = UIMenu(title: "Sort by",options: .singleSelection, children: [sortByAmount,sortByCreatedDate])

        let sortButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.up.arrow.down"), primaryAction: nil, menu: sortMenu!)
       
        
        let todayFilter = UIAction(title: "Today") { _ in
            
            self.filterClue = .today
            self.presenter?.didChangeFilter(filterClue: .today)
        }
        
        
        let thisWeekFilter = UIAction(title: "This week") { _ in
            
            self.filterClue = .thisWeek
            self.presenter?.didChangeFilter(filterClue: .thisWeek)
        }
        
        let thisMonthFilter = UIAction(title: "This month") { _ in
           
            self.filterClue = .thisMonth
            self.presenter?.didChangeFilter(filterClue: .thisMonth)
        }
        
        let thisYearFilter = UIAction(title: "This year") { _ in
            
            self.filterClue = .thisYear
            self.presenter?.didChangeFilter(filterClue: .thisYear)
        }
        
        let overAllFilter = UIAction(title: "All") { _ in
            
            self.filterClue = .all
            self.presenter?.didChangeFilter(filterClue: .all)
        }
        
        overAllFilter.state = .on
        self.navigationItem.title = "All"
        
        
        
        filterMenu = UIMenu(options: .singleSelection, children: [todayFilter,thisWeekFilter,thisMonthFilter,thisYearFilter,overAllFilter])
        
        
        let filterButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "line.3.horizontal.decrease"), primaryAction: nil, menu: filterMenu!)
        
        
        
        
        navigationItem.rightBarButtonItems = [sortButton,filterButton]
//
//        navigationItem.rightBarButtonItems = [sortButton]
        
        navigationController?.navigationBar.prefersLargeTitles = true
       
    }
    
    @objc func tappedEdit(){
        navigationController?.pushViewController(ExpenseDetailVC(), animated: true)
    }

    
//    @objc func sortByAmount(){
//        presenter?.sortByAmount()
//    }
//
//    @objc func sortByCreatedDate(){
//        presenter?.sortByCreatedDate()
//    }
//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.loadExpenses()
        table.reloadData()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        presenter?.loadExpenses()
//        table.reloadData()
    }
    
    
    @objc func plusBtnTapped(){
        
        let  addExpenseVC = AddExpenseVC()
        let presenter = AddExpensePresenter()
        presenter.view = addExpenseVC
        addExpenseVC.presenter = presenter
        
        navigationController?.pushViewController(addExpenseVC, animated: true)
    }
    
    
    
}















extension RecordsVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.noOfRecords() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.reuseId) as! ExpenseTableViewCell
        let expense = (presenter?.dataForCellAt(indexPath: indexPath))!
        cell.expenseID = expense.id
        cell.title = expense.title
        cell.amount = expense.amount
        cell.category = expense.category
        cell.date = expense.date
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let cell = table.cellForRow(at: indexPath) as? ExpenseTableViewCell else{
            return
        }
        
        
        presenter?.didSelectCellAt(indexPath: indexPath, cellData: RecordsTableCellData(id: cell.expenseID ?? "", amount: cell.amount, title: cell.title, category: cell.category, date: cell.date))
      
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            presenter?.deleteCellAt(indexPath: indexPath)
        }
    }
    
}











extension RecordsVC: RecordsView{
    var contextTitle: String? {
        get {
            self.navigationItem.title
        }
        set {
            self.navigationItem.title = newValue
        }
    }
    
    
    
    
    
    
    
    func showExpense(expense: ExpenseWithAttachmentsData) {
        let detailVC =  ExpenseDetailVC()
        let presenter = ExpenseDetailPresenter(expense: expense)
        presenter.expense = expense
        presenter.view = detailVC
        detailVC.presenter = presenter
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func refreshView() {
//        table.reloadData()
        UIView.transition(with: table, duration: 0.35, options: .transitionCrossDissolve, animations: {self.table.reloadData()}, completion: nil)
    }
    
    func showNoRecordsView() {
        print(#function)
        noRecordsView.isHidden = false
    }
    
    func hideNoRecordsView() {
        print(#function)
        noRecordsView.isHidden = true
    }
    
    
}
















let attachmentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]











class ExpenseTableViewCell: UITableViewCell{
    static let reuseId = "expenseCell"
    
    var expenseID: String?
    
    var title: String?{
        get{
            mainTitleLabel.text
        }
        set{
            mainTitleLabel.text = newValue
        }
    }
    
    var date: String?{
        get{
            dateLabel.text
        }
        set{
            dateLabel.text = newValue
        }
    }
    
    var category: String?{
        get{
            categoryLabel.text
        }
        set{
            categoryLabel.text = newValue
        }
    }
    
    var amount: String?{
        get{
            amountLabel.text
        }
        set{
            amountLabel.text = newValue
        }
    }
    
    
    
    
    
    
    private lazy var mainTitleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Untitled"
        label.font = .systemFont(ofSize: 20)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private lazy var categoryLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16,weight: .thin)
        label.sizeToFit()
        return label
    }()
    
    private lazy var amountLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14,weight: .thin)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        
        
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            amountLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor, constant: 15),

            categoryLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 5),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 5)
        ])
        
        
    }
    
    
    
    
}





struct RecordsTableCellData{
    let id: String
    let amount: String?
    let title: String?
    let category: String?
    let date: String?
    
    
}
