//
//  ExpenseDetailVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 22/03/23.
//

import UIKit




protocol ExpenseDetailPresenterProtocol{
    
    func viewDidLoad()
    func editTapped()
    
}




class ExpenseDetailVC: UIViewController{
    
    
    var presenter: ExpenseDetailPresenterProtocol?
    

    var fields = [FormField](){
        didSet{
            
            fields.forEach { field in
                field.register(for: table)
                if let attachmentsField = field as? AttachmentsField{
                    attachmentsField.configurationHandler = self
                }
            }
            
            
            table.reloadData()
        }
    }
    
    private lazy var table = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.sectionHeaderTopPadding = 0
        table.separatorStyle = .none
        
        return table
    }()
    
    private lazy var attachmentsVC = {
        AttachmentsVC()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        
        table.pinToSafeArea(view: view)
        table.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
       
        
        navigationItem.largeTitleDisplayMode = .never
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEdit))
        
        
        self.addChild(attachmentsVC)
        attachmentsVC.didMove(toParent: self)
        attachmentsVC.allowsDelete = false
        
        presenter?.viewDidLoad()
        
    }
    
    @objc func didTapEdit(){
        presenter?.editTapped()
    }

}


extension ExpenseDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fields.count
    }
    
    


    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        fields[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let field = fields[indexPath.row]
        return field.dequeue(for: table, at: indexPath)
    }
    
 
}



extension ExpenseDetailVC: ExpenseDetailView{
    func showEditScreen(for expense: Expense) {
        let  addExpenseVC = AddExpenseVC()
        let presenter = AddExpensePresenter()
        presenter.expense = expense
        presenter.view = addExpenseVC
        addExpenseVC.presenter = presenter
        
        navigationController?.pushViewController(addExpenseVC, animated: true)
    }
    
 
    
  
}

extension ExpenseDetailVC: AttachmentsConfigurationHandler {
    
    func viewFor(field: AttachmentsField) -> UIView? {
        return attachmentsVC.view
    }
    
    func updateAttachmentsData(field: AttachmentsField, data: [Data]) {
        attachmentsVC.attachments = data
    }
    
}






class AttachmentsCell: UITableViewCell{
    
    static let reuseID = "Attachments cell"
    
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        label.textColor = .placeholderText
        label.text = "Attachments"
        return label
    }()
    
    var attachmentsView: UIView = UIView() {
        willSet{
            attachmentsView.removeFromSuperview()
        }
        didSet{
            contentView.addSubview(attachmentsView)
            contentView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                titleLabel.bottomAnchor.constraint(equalTo: attachmentsView.topAnchor, constant: -10),

                
                attachmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                attachmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                attachmentsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            ])
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView(){
        
        attachmentsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(attachmentsView)
        //        mainStack.pinToSafeArea(view: contentView)
        NSLayoutConstraint.activate([
            
            attachmentsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            attachmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            attachmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            attachmentsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
        ])
        
        
    }
   
    
    override func prepareForReuse() {
        super.prepareForReuse()
        attachmentsView.removeFromSuperview()
    }
    
    
    
}
    




class DetailTableViewCell: UITableViewCell{

    
    static let reuseID = "Detail table cell"
    

    
    private lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        label.textColor = .placeholderText
        return label
    }()
    
    private lazy var detailLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .regular)
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
        
        selectionStyle = .none
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel,detailLabel])
        mainStack.axis = .vertical
        mainStack.distribution = .equalCentering
        
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        
       
        
        contentView.addSubview(mainStack)

        mainStack.pinToSafeArea(view: contentView)
        
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
    }
    
    
    func configure(with cellData: (title: String?,detail: String?)){
        
        titleLabel.text = cellData.title
        detailLabel.text = cellData.detail
        
    }


}

