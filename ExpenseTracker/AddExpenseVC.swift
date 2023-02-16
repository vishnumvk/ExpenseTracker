//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 19/01/23.
//

import UIKit
import PhotosUI






enum ExpenseCategory: String,CaseIterable{
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


enum TextFieldTag: Int{
    case title = 100
    case amount = 101
}

protocol AddExpensePresenterProtocol: AnyObject{
    
    
    func camBtnTapped()
    func clipBtnTapped()
    
}


import AVFoundation
import Photos


class AddExpensePresenter: AddExpensePresenterProtocol{
    
    
    func clipBtnTapped() {
        
        
        delegate?.openPhotoLibrary()
        
//        switch PHPhotoLibrary.authorizationStatus(for: .addOnly){
//        case .authorized:
//            delegate?.openPhotoLibrary()
//        case .denied:
//            delegate?.presentPhotoLibrarySettings()
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
//                switch status{
//                case .authorized:
//                    self?.delegate?.openPhotoLibrary()
//                default:
//                    print("photo library access was denied")
//                }
//            }
//        default:
//            print("unhandled authorization status")
//        }
    }
    
    
    
    
    func camBtnTapped() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                 delegate?.presentCameraSettings()
            case .restricted:
                 delegate?.presentCameraSettings()
            case .authorized:
                 delegate?.openCamera()
            case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [self] success in
                    if success {
                        delegate?.openCamera()
                    } else {
                        print("Permission denied")
                    }
                }
        @unknown default:
            print("Unknown case")
        }
        }
        
        
        
    
    
    
    
    
    weak var delegate: AddExpenseViewDelegate?
    
    
    
    
    
    
    
}




class AddExpenseVC: UIViewController {
    
    
    
    lazy var presenter = {
       let presenter = AddExpensePresenter()
        presenter.delegate = self
        return presenter
    }()
    
    
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
       
        return datePicker
    }()
    
    private lazy var dateStack = {
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
    private lazy var dateLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText
        return label
    }()
    
    private lazy var stackView = {
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
    
    
    private lazy var titleField = {
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
    
    private lazy var amountField = {
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
    
    
    
    private lazy var noteStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        return stack
    }()
    
    
    private lazy var noteField = {
        let note = UITextView()
        note.translatesAutoresizingMaskIntoConstraints = false
        note.font = .systemFont(ofSize: 20)
        note.textColor = .label

        note.textAlignment = .left
        note.isScrollEnabled = false

        note.textColor = .label
        note.layer.cornerRadius = 5
        note.layer.borderWidth = 1
        note.layer.borderColor = UIColor.placeholderText.cgColor
        return note
    }()
    
    private lazy var noteLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Note"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText

        return label
    }()
    
    
    private lazy var camBtn = {
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
    
    private lazy var clipBtn = {
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
    
    private lazy var attachmentLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add bill image"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText
        return label
    }()
    
    
    private lazy var scrollContainer = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.bounces = true
        return scroll
    }()
    
    private lazy var categoryBtn = {
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
    
    
    private lazy var attachmentOptions = {
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
    
    private lazy var attachmentsVC = {
        AttachmentsVC()
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add Expense"
       
       
        view.addSubview(scrollContainer)
        scrollContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollContainer.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        scrollContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        scrollContainer.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollContainer.frameLayoutGuide.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollContainer.frameLayoutGuide.leadingAnchor).isActive = true
//        stackView.widthAnchor.constraint(equalTo: scrollContainer.frameLayoutGuide.widthAnchor).isActive = true
        
        dateStack.addArrangedSubview(dateLabel)
//        dateStack.addArrangedSubview(Spacer())
        dateStack.addArrangedSubview(datePicker)
        
       
        noteStack.addArrangedSubview(noteLabel)
        noteStack.addArrangedSubview(noteField)
        
        stackView.addArrangedSubview(amountField)
        stackView.addArrangedSubview(titleField)
        stackView.addArrangedSubview(dateStack)
        stackView.addArrangedSubview(categoryBtn)
        stackView.addArrangedSubview(noteStack)
        stackView.addArrangedSubview(attachmentOptions)
        
//        stackView.addArrangedSubview(Spacer())
        
        
        self.addChild(attachmentsVC)
        
        attachmentsVC.view.translatesAutoresizingMaskIntoConstraints = false
        attachmentsVC.view.heightAnchor.constraint(equalToConstant: 310).isActive = true
        stackView.addArrangedSubview(attachmentsVC.view)
        
        attachmentsVC.didMove(toParent: self)
       
        applyColours()
        
//        let keyBoardToolBar = UIToolbar()
//        keyBoardToolBar.translatesAutoresizingMaskIntoConstraints = false
//        let done = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(amountField.resignFirstResponder))
//
//        keyBoardToolBar.items = [UIBarButtonItem.flexibleSpace(),done]
//        keyBoardToolBar.sizeToFit()
//        amountField.inputAccessoryView = keyBoardToolBar
        amountField.doneAccessory = true
        noteField.doneAccessory = true
        titleField.doneAccessory = true
        
    }
   
    
    @objc func categoryButtonTapped(){
        
        let optionsVC = SelectionViewController(options: ExpenseCategory.allCases.map{$0.rawValue})
        
        optionsVC.modalPresentationStyle = .pageSheet
        
        optionsVC.didSelectOption = { [weak self] selectedOption in
            
            self?.categoryBtn.setTitle(selectedOption, for: .normal)
            
        }
        
        present(optionsVC, animated: true)
        
        
    }
    
  
    
    @objc func camButtonTapped(){
        
        presenter.camBtnTapped()
        
    }
    
    
    @objc func clipButtonTapped(){
       
        
        presenter.clipBtnTapped()
        
    }
    
    
    func applyColours(){
             view.backgroundColor  = UIColor.systemGroupedBackground
        dateStack.backgroundColor  = UIColor.secondarySystemGroupedBackground
        titleField.backgroundColor = UIColor.secondarySystemGroupedBackground
       amountField.backgroundColor = UIColor.secondarySystemGroupedBackground
       categoryBtn.backgroundColor = UIColor.secondarySystemGroupedBackground
         noteField.backgroundColor = UIColor.secondarySystemGroupedBackground
 attachmentOptions.backgroundColor = UIColor.secondarySystemGroupedBackground
              datePicker.tintColor = .systemTeal
             amountField.tintColor = .systemTeal
              titleField.tintColor = .systemTeal
               noteField.tintColor = .systemTeal
        
         dateStack.layer.borderColor  = UIColor.systemTeal.cgColor
         titleField.layer.borderColor = UIColor.systemTeal.cgColor
        amountField.layer.borderColor = UIColor.systemTeal.cgColor
        categoryBtn.layer.borderColor = UIColor.systemTeal.cgColor
          noteField.layer.borderColor = UIColor.systemTeal.cgColor
  attachmentOptions.layer.borderColor = UIColor.systemTeal.cgColor
        
        navigationController?.navigationBar.tintColor = .systemTeal
        navigationController?.toolbar.tintColor = .systemTeal
        
        
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
            applyColours()
        }
    }
    
    
    
    
    
}




protocol AddExpenseViewDelegate: NSObject{
    
    func openCamera()
    func presentCameraSettings()
    func openPhotoLibrary()
    func presentPhotoLibrarySettings()
}














extension AddExpenseVC: AddExpenseViewDelegate{
    
    func openPhotoLibrary(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    

    func openCamera(){
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
    
    
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "App does not have access to your camera. To enable access, tap settings and turn on Camera", message: nil,preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        })

        present(alertController, animated: true)
    }
    
    func presentPhotoLibrarySettings() {
        let alertController = UIAlertController(title: "App does not have access to Photos. To enable access, tap settings and allow to add to photos", message: nil,preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        })

        present(alertController, animated: true)
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

        attachmentsVC.attachments.append(image)

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
        
        for result in results{
            
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                guard let url = url else {
                    
                    return
                }
                
                let image = downsample(imageAt: url, to: .init(width: 100, height: 120)) ?? UIImage(systemName: "photo")
                DispatchQueue.main.async {
                    self.displayImage(image: image!)
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
//    func textFieldDidBeginEditing(_ textField: UITextField){
//        textField.layer.borderColor = UIColor.systemGreen.cgColor
//
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.layer.borderColor = UIColor.systemTeal.cgColor
//    }
}















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
        table.pinToSafeArea(view: view)
        
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





















extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}





extension UITextView{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}



