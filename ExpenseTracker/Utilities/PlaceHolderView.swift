//
//  PlaceHolderView.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 19/03/23.
//

import UIKit



class PlaceHolderView: UIView{
    
    var image: UIImage?{
        didSet{
            if let image{
                imageView.image = image
                imageView.isHidden = false
            }else{
                imageView.isHidden = true
            }
        }
    }
    
    var text: String?{
        didSet{
            textLabel.text = text
        }
    }
    
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var textLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .placeholderText
        label.font = .italicSystemFont(ofSize: 20)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpView(){
        let stack = UIStackView(arrangedSubviews: [imageView,textLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        
        addSubview(stack)
//        stack.pinToSafeArea(view: self)
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
}

