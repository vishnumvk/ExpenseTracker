//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 19/01/23.
//

import UIKit
import PhotosUI






enum Categories: String,CaseIterable{
    case houseHold = "House hold"
    case Electricity
    case Education
    case Food
    case Clothing
    case Travel
    case Groceries
    case Entertainment
    case Health
    case Others
}


enum TextFields: Int{
    case title = 100
    case amount = 101
}




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
        stackView.spacing = 15
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
        textfield.delegate = self
        
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
        textfield.delegate = self
        
        textfield.keyboardType = .decimalPad
        
        
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
        note.delegate = self
        note.heightAnchor.constraint(equalToConstant: 44).isActive = true
        note.layer.cornerRadius = 5
        note.layer.borderWidth = 1
        note.layer.borderColor = UIColor.placeholderText.cgColor
        return note
    }()

    
    
//    lazy var noteField = {
//        let note = UITextView()
//        note.translatesAutoresizingMaskIntoConstraints = false
//        note.font = .systemFont(ofSize: 20)
//        note.textColor = .label
////        note.placeholder = "Note"
////        note.borderStyle = .roundedRect
//        note.textAlignment = .left
//        note.isScrollEnabled = false
//
//        note.textColor = .label
//        note.layer.cornerRadius = 5
//        note.layer.borderWidth = 1
//        note.layer.borderColor = UIColor.placeholderText.cgColor
//        return note
//    }()
//
    
    
    lazy var camBtn = {
        let btn = UIButton()
        let image = UIImage(systemName: "camera")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(camButtonTapped), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = .label
//        btn.backgroundColor = .systemCyan
        btn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        btn.imageView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.imageView?.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    
    lazy var clipBtn = {
        let btn = UIButton()
        let image = UIImage(systemName: "paperclip")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(clipButtonTapped), for: .touchUpInside)
//        btn.backgroundColor = .systemCyan
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = .label
        btn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        btn.imageView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.imageView?.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    
    lazy var attachmentLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add bill image"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText
        return label
    }()
    
    
    lazy var scrollContainer = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.bounces = true
        return scroll
    }()
    
    lazy var categoryBtn = {
        var btn = UIButton()
        let image = UIImage(systemName: "chevron.down")
        btn.setTitle("Category", for: .normal)
        btn.setImage(image, for: .normal)
        btn.setTitleColor(UIColor.label, for: .normal)
        btn.contentHorizontalAlignment = .fill
        
        
        btn.tintColor = .label
        btn.configuration = .plain()
        
        btn.configuration?.imagePlacement = .trailing
        
       
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.placeholderText.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
        
    }()
    
    
    lazy var attachmentOptions = {
        let stack = UIStackView(arrangedSubviews: [attachmentLabel,Spacer(),camBtn,clipBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.layer.cornerRadius = 5
        stack.layer.borderWidth = 1
        stack.layer.borderColor = UIColor.placeholderText.cgColor
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
       
        return stack
    }()
    
    let attachmentsVC = AttachmentsVC()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add Expense"
       

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
        
       
        
        stackView.addArrangedSubview(amountField)
        stackView.addArrangedSubview(titleField)
        stackView.addArrangedSubview(dateStack)
        stackView.addArrangedSubview(categoryBtn)
        stackView.addArrangedSubview(noteField)
        stackView.addArrangedSubview(attachmentOptions)
        
//        stackView.addArrangedSubview(Spacer())
        
        
        self.addChild(attachmentsVC)
        
        attachmentsVC.view.translatesAutoresizingMaskIntoConstraints = false
        attachmentsVC.view.heightAnchor.constraint(equalToConstant: 310).isActive = true
        stackView.addArrangedSubview(attachmentsVC.view)
        
        attachmentsVC.didMove(toParent: self)
       
        
        
    }
   
    
    @objc func categoryButtonTapped(){
        
        let optionsVC = SelectionViewController(options: Categories.allCases.map{$0.rawValue})
        
        optionsVC.modalPresentationStyle = .pageSheet
        
        optionsVC.didSelectOption = { selectedOption in
            
            self.categoryBtn.setTitle(selectedOption, for: .normal)
            
        }
        
        present(optionsVC, animated: true)
        
        
    }
    
  
    
    @objc func camButtonTapped(){
        
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            pickerVC.sourceType = .camera
            
        }
        else{
            let ac = UIAlertController(title: "Camera not found", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            return
        }
      
        present(pickerVC, animated: true)
    }
    
    
    @objc func clipButtonTapped(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        present(picker, animated: true)
        
        
        
    }
    
    
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
            dateStack.layer.borderColor = UIColor.placeholderText.cgColor
            titleField.layer.borderColor = UIColor.placeholderText.cgColor
            amountField.layer.borderColor = UIColor.placeholderText.cgColor
            categoryBtn.layer.borderColor = UIColor.placeholderText.cgColor
            noteField.layer.borderColor = UIColor.placeholderText.cgColor
            attachmentOptions.layer.borderColor = UIColor.placeholderText.cgColor
//            UIDatePicker.appearance().tintColor = .systemMint
            datePicker.tintColor = .systemMint
        }
    }
    
    
    
    
    
}





extension AddExpenseVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.main.async { [self] in
           
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                displayImage(image: image)
                
                
                let alert = UIAlertController(title: "Save Image", message: "Would you like to save the image to photos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                }))
                
                present(alert, animated: true)
                
                
                
            }
            
            
            
            
        }
        picker.dismiss(animated: true)
    }
    
    
    
    
    func displayImage(image: UIImage){
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        stackView.addArrangedSubview(imageView)
//        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        imageView.image = image
        attachmentsVC.attachments.append(image)
//        present(AttachmentsVC(), animated: true)
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
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


extension AddExpenseVC: PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        //        for result in results {
        //            if result.itemProvider.canLoadObject(ofClass: UIImage.self){
        //                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
        //                    if let error = error {
        //                        print(error.localizedDescription)
        //                    }
        //
        //                    if let image = object as? UIImage {
        //                        DispatchQueue.main.async {
        //                            self.displayImage(image: image)
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //
        //        picker.dismiss(animated: true)
        //
        for result in results{
            
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                guard let url = url else {
                    
                    return
                }
                
                
                let image = downsample(imageAt: url, to: .init(width: 100, height: 120))!
                DispatchQueue.main.async {
                    self.displayImage(image: image)
                }
            }
            
        }
        picker.dismiss(animated: true)
    }
}



extension AddExpenseVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}









//extension UIColor{
//    static var placeholderText: UIColor {
//        get{
//            return UIColor.systemCyan
//        }
//    }
//}









class SelectionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    init(options: [String]) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didSelectOption : ((_ selectedOption: String) -> ())?
    
    lazy var table = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.separatorStyle = .singleLine
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.isPagingEnabled = true
        return table
    }()
    

    
    private var options: [String]
    
    override func viewDidLoad() {
        
        view.addSubview(table)
        table.pinTo(view: view)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row]
       
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = .systemFont(ofSize: 20)
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectOption{
            didSelectOption(options[indexPath.row])
        }
        dismiss(animated: true)
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
//        backgroundColor = .gray
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







func downsample(imageAt imageURL: URL,
                to pointSize: CGSize,
                scale: CGFloat = UIScreen.main.scale) -> UIImage? {
    
    // Create an CGImageSource that represent an image
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
        print("source error")
        return nil
    }
    
    // Calculate the desired dimension
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    
    // Perform downsampling
    let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ] as CFDictionary
    
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
        print("down sampling error")
        return nil
    }
    
    // Return the downsampled image as UIImage
    return UIImage(cgImage: downsampledImage)
}

