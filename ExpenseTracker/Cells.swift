//
//  Cells.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 21/03/23.
//

import UIKit


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


//class DateNavigatorView: UIView{
//    private let segmentedControl = {
//        let segmentedControl = UISegmentedControl(items: ["Day","Week","Month","Year","All"])
//        segmentedControl.selectedSegmentIndex = 2
//        return segmentedControl
//    }()
//
//    init(frame: CGRect,segmentItems: [String]) {
//        super.init(frame: frame)
//        segmentedControl
//        commonInit()
//    }
//    convenience init(segmentItems: [String]) {
//        self.init(frame: .zero, segmentItems: segmentItems)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func commonInit(){
//
//
//    }
//
//}
