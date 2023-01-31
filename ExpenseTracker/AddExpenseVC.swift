//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 19/01/23.
//

import UIKit


class AddExpenseVC: UIViewController {
    
    lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
       
        return datePicker
    }()
    
    lazy var dateStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.layer.cornerRadius = 5
        stack.layer.borderWidth = 1
        stack.layer.borderColor = UIColor.placeholderText.cgColor
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        return stack
    }()
    lazy var dateLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText
        return label
    }()
    
    lazy var stackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()
    
    
    lazy var titleField = {
       let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textColor = .label
        textfield.textAlignment = .left
        textfield.font = .systemFont(ofSize: 20)
        textfield.placeholder = "Title"
        textfield.borderStyle = .roundedRect
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.placeholderText.cgColor
        
        
        
        
        return textfield
    }()
    
    lazy var amountField = {
       let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textColor = .label
        textfield.textAlignment = .left
        textfield.font = .systemFont(ofSize: 18)
        textfield.placeholder = "Amount"
        textfield.borderStyle = .roundedRect
        
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.placeholderText.cgColor
        
        
        return textfield
    }()
    
    
    lazy var noteField = {
        let note = UITextField()
        note.translatesAutoresizingMaskIntoConstraints = false
        note.font = .systemFont(ofSize: 20)
        note.textColor = .label
        note.placeholder = "Note"
        note.borderStyle = .roundedRect
        note.textAlignment = .left
        note.heightAnchor.constraint(equalToConstant: 44).isActive = true
        note.layer.cornerRadius = 5
        note.layer.borderWidth = 1
        note.layer.borderColor = UIColor.placeholderText.cgColor
        return note
    }()
    
    lazy var camBtn = {
        let btn = UIButton()
        let image = UIImage(systemName: "camera")
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(camButtonTapped), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleToFill
        btn.imageView?.tintColor = .label
        btn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        btn.imageView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.imageView?.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return btn
    }()
    
    lazy var scrollContainer = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.bounces = false
        return scroll
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add Expense"
       
//        view.addSubview(stackView)
//        stackView.pinTo(view: view)
        view.addSubview(scrollContainer)
        scrollContainer.pinTo(view: view)
        
        scrollContainer.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.leadingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollContainer.frameLayoutGuide.widthAnchor).isActive = true
        
        dateStack.addArrangedSubview(dateLabel)
//        dateStack.addArrangedSubview(Spacer())
        dateStack.addArrangedSubview(datePicker)
        
       
        
        
        stackView.addArrangedSubview(titleField)
        stackView.addArrangedSubview(dateStack)
        stackView.addArrangedSubview(amountField)
        stackView.addArrangedSubview(noteField)
        stackView.addArrangedSubview(camBtn)
        
//        stackView.addArrangedSubview(Spacer())
        
        
        
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("date width: \(dateStack.frame.height)")
    }
    
    @objc func camButtonTapped(){
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            pickerVC.sourceType = .camera
            
        }
        else{
            
            pickerVC.sourceType = .photoLibrary
            
        }
        
        
       
        present(pickerVC, animated: true)
    }
    
}





extension AddExpenseVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        DispatchQueue.main.async { [self] in
            self.stackView.addArrangedSubview(imageView)
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imageView.image = image
                
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                
                
            }
            
            
            
            
        }
        picker.dismiss(animated: true)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: " Image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}














class Spacer: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setContentCompressionResistancePriority(.init(1), for: .vertical)
        setContentCompressionResistancePriority(.init(1), for: .horizontal)
        setContentHuggingPriority(.init(1), for: .vertical)
        setContentHuggingPriority(.init(1), for: .horizontal)
        backgroundColor = .gray
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        width.priority = .init(1)
        
        let height = heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
        height.priority = .init(1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






extension UIView{
    func pinTo(view: UIView){
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        
        ])
    }
}





