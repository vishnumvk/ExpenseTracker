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













class AddExpenseVC: UIViewController {
    
    
    

    var presenter: AddExpensePresenterProtocol?
    
    private let fieldBoarderWidth: CGFloat = 1.5
    
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .secondarySystemGroupedBackground
        return datePicker
    }()
    
    private lazy var dateStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.layer.cornerRadius = 5
        stack.layer.borderWidth = fieldBoarderWidth
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
    
    private lazy var titleStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText

        return label
    }()
    
    private lazy var titleField = {
       let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textColor = .label
        textfield.textAlignment = .left
        textfield.font = .systemFont(ofSize: 20)
        textfield.delegate = self
        
        textfield.tag = TextFieldTag.title.rawValue
        textfield.borderStyle = .roundedRect
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = fieldBoarderWidth
        textfield.layer.borderColor = UIColor.placeholderText.cgColor
        
        
        
        
        return textfield
    }()
    
    private lazy var amountField = {
       let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textColor = .label
        textfield.textAlignment = .left
        textfield.font = .systemFont(ofSize: 18)
//        textfield.placeholder = "Amount"
        textfield.borderStyle = .roundedRect
        textfield.delegate = self
        
        textfield.keyboardType = .decimalPad
        textfield.tag = TextFieldTag.amount.rawValue
        
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = fieldBoarderWidth
        textfield.layer.borderColor = UIColor.placeholderText.cgColor
        
        
        return textfield
    }()
    
    private lazy var amountLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Amount"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText

        return label
    }()
    
    private lazy var amountWarning = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed

        return label
    }()
    
    private lazy var amountStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    
    private lazy var noteStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    
    private lazy var noteField = {
        let note = UITextView()
        note.translatesAutoresizingMaskIntoConstraints = false
        note.font = .systemFont(ofSize: 20)
        note.textColor = .label
        note.delegate = self
        note.textAlignment = .left
        note.isScrollEnabled = false

        note.textColor = .label
        note.layer.cornerRadius = 5
        note.layer.borderWidth = fieldBoarderWidth
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
        label.text = "Add Attachments"
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
    
    private lazy var categoryStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    private lazy var categoryLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText
        return label
    }()
    
    private lazy var categoryWarning = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "please select category"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed

        return label
    }()
    
    private lazy var categoryBtn = {
        var btn = UIButton()
        let image = UIImage(systemName: "chevron.down")
        btn.setTitle("None", for: .normal)
        btn.setImage(image, for: .normal)
        btn.setTitleColor(UIColor.label, for: .normal)
        btn.contentHorizontalAlignment = .fill
        
        
        btn.tintColor = .systemTeal
        btn.configuration = .plain()
        
        btn.configuration?.imagePlacement = .trailing
        
       
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.placeholderText.cgColor
        btn.layer.borderWidth = fieldBoarderWidth
        btn.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
        
    }()
    
    
    
    private lazy var attachmentsBtn = {
        var btn = UIButton()
        let image = UIImage(systemName: "plus")
        btn.setTitle("Add Attachments", for: .normal)
        btn.setImage(image, for: .normal)
        btn.setTitleColor(UIColor.label, for: .normal)
        btn.contentHorizontalAlignment = .fill
        
        
        btn.tintColor = .systemTeal
        btn.configuration = .plain()
        
        btn.configuration?.imagePlacement = .trailing
        
       
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.placeholderText.cgColor
        btn.layer.borderWidth = fieldBoarderWidth
        
        btn.showsMenuAsPrimaryAction = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
        
    }()
    
    
    
    
    
    
//    private lazy var attachmentOptions = {
//        let stack = UIStackView(arrangedSubviews: [attachmentLabel,Spacer(),camBtn,clipBtn])
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .horizontal
//        stack.distribution = .fill
//        stack.spacing = 15
//        stack.layer.cornerRadius = 5
////        stack.layer.borderWidth = fieldBoarderWidth
////        stack.layer.borderColor = UIColor.placeholderText.cgColor
//        stack.isLayoutMarginsRelativeArrangement = true
//        stack.directionalLayoutMargins = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
//
//        return stack
//    }()
    
    private lazy var attachmentsVC = {
        AttachmentsVC()
    }()
    
//    private var imageToBeSaved: UIImage?
    init(){
        
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Add Expense"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tappedSave))
        
       
        presenter?.viewDidLoad()
        
        view.addSubview(scrollContainer)
        scrollContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollContainer.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        scrollContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        scrollContainer.alwaysBounceVertical = true
        
        scrollContainer.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollContainer.contentLayoutGuide.leadingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollContainer.frameLayoutGuide.widthAnchor).isActive = true
        
        dateStack.addArrangedSubview(dateLabel)
//        dateStack.addArrangedSubview(Spacer())
        dateStack.addArrangedSubview(datePicker)
        
       
        noteStack.addArrangedSubview(noteLabel)
        noteStack.addArrangedSubview(noteField)
        
        amountStack.addArrangedSubview(amountLabel)
        amountStack.addArrangedSubview(amountField)
        amountStack.addArrangedSubview(amountWarning)
        
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(titleField)
        
        
        categoryStack.addArrangedSubview(categoryLabel)
        categoryStack.addArrangedSubview(categoryBtn)
        categoryStack.addArrangedSubview(categoryWarning)
        
        stackView.addArrangedSubview(amountStack)
        stackView.addArrangedSubview(titleStack)
        stackView.addArrangedSubview(dateStack)
        stackView.addArrangedSubview(categoryStack)
        stackView.addArrangedSubview(noteStack)
        stackView.addArrangedSubview(attachmentsBtn)
        
//        stackView.addArrangedSubview(Spacer())
        
        
        self.addChild(attachmentsVC)

        attachmentsVC.view.translatesAutoresizingMaskIntoConstraints = false
        attachmentsVC.view.heightAnchor.constraint(equalToConstant: 310).isActive = true
        stackView.addArrangedSubview(attachmentsVC.view)

        attachmentsVC.didMove(toParent: self)
       
        applyColours()
        
//        amountField.addDoneButtonOnKeyboard()
//          noteField.addDoneButtonOnKeyboard()
//         titleField.addDoneButtonOnKeyboard()
        
          amountWarning.isHidden = true
        categoryWarning.isHidden = true
//
       hideKeyboardWhenTappedAround()
        
        let cameraAction = UIAction(title: "Take Photo", image: UIImage(systemName: "camera")) { _ in
            self.camButtonTapped()
        }
        
        let galleryAction = UIAction(title: "Photo Library", image: UIImage(systemName: "photo.on.rectangle")) { _ in
            self.clipButtonTapped()
        }
        
        attachmentsBtn.menu = UIMenu(children: [cameraAction,galleryAction])
        
        
    }
    
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if restorationValues != nil{
            restoreView(with: restorationValues)
        }

        restorationValues = nil
        updateUserActivity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentUserActivity = view.window?.windowScene?.userActivity {
            print("removing state restoration on add expense ")
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.presentedAddExpenseKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.amountKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.titleKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.categoryKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.dateKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.attachmentsKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.presentSaveImageToCameraAlertKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.capturedImageKey)
            currentUserActivity.userInfo?.removeValue(forKey: StateRestorationConstants.noteKey)
        }
    }
    
    
    
    
   
    
    @objc func categoryButtonTapped(){
        
        let optionsVC = SelectionViewController(options: ExpenseCategory.allCases.map{$0.rawValue})
        
        optionsVC.modalPresentationStyle = .pageSheet
        
        optionsVC.didSelectOption = { [weak self] selectedOption in
            
            self?.categoryBtn.setTitle(selectedOption, for: .normal)
            self?.categoryFieldWarning = nil
            
        }
        
        present(optionsVC, animated: true)
        
        
    }
    
  
    
    @objc func camButtonTapped(){
        print(#function)
        presenter?.camBtnTapped()
        
    }
    
    
    @objc func clipButtonTapped(){
       
        
        presenter?.clipBtnTapped()
        
    }
    
    @objc func tappedSave(){
        
        presenter?.tappedSave()
    }
    
    
    
    
    
    
    
    func applyColours(){
             view.backgroundColor  = UIColor.systemGroupedBackground
        dateStack.backgroundColor  = UIColor.secondarySystemGroupedBackground
        titleField.backgroundColor = UIColor.secondarySystemGroupedBackground
       amountField.backgroundColor = UIColor.secondarySystemGroupedBackground
       categoryBtn.backgroundColor = UIColor.secondarySystemGroupedBackground
         noteField.backgroundColor = UIColor.secondarySystemGroupedBackground
 attachmentsBtn.backgroundColor = UIColor.secondarySystemGroupedBackground
              datePicker.tintColor = .systemTeal
             amountField.tintColor = .systemTeal
              titleField.tintColor = .systemTeal
               noteField.tintColor = .systemTeal
        
         dateStack.layer.borderColor  = UIColor.systemTeal.cgColor
         titleField.layer.borderColor = UIColor.systemTeal.cgColor
        amountField.layer.borderColor = UIColor.systemTeal.cgColor
        categoryBtn.layer.borderColor = UIColor.systemTeal.cgColor
          noteField.layer.borderColor = UIColor.systemTeal.cgColor
  attachmentsBtn.layer.borderColor = UIColor.systemTeal.cgColor
        
//        navigationController?.navigationBar.tintColor = .systemTeal
       
        
        
        
        
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
            applyColours()
        }
    }
    
    
    var restorationValues: [AnyHashable: Any]!
    
    var expenseID: String? = nil
    
    
    
}

















extension AddExpenseVC: AddExpenseView{
    
    
    var amountFieldWarning: String?{
        
        get{
            amountWarning.text
        }
        set{
            if let newValue {
                amountWarning.text = newValue
                amountWarning.isHidden = false
            }else{
                amountWarning.isHidden = true
            }
        }
    }
    
    
    var categoryFieldWarning: String?{
        
        get{
            categoryWarning.text
        }
        set{
            if let newValue {
                categoryWarning.text = newValue
                categoryWarning.isHidden = false
            }else{
                categoryWarning.isHidden = true
            }
        }
    }
    
    
    
    
    
    var navTitle: String? {
        get {
            return title
        }
        set {
            title = newValue
        }
    }
    
    
    
    
    var expenseTitle: String? {
        get {
            if let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
               return title == "" ? nil : title
            }
            return titleField.text
        }
        set {
            titleField.text = newValue
        }
    }
    
    var attachments: [Data] {
        get {
            attachmentsVC.attachments
        }
        set {
            attachmentsVC.attachments = newValue
        }
    }
    
    
    var amount: String? {
        get {
            amountField.text
        }
        set {
            amountField.text = newValue
        }
    }
    
    var category: String? {
        get {
            categoryBtn.currentTitle
        }
        set {
            categoryBtn.setTitle(newValue, for: .normal)
        }
    }
    
    var note: String? {
        get {
            if let title = noteField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
               return title == "" ? nil : title
            }
            return noteField.text
        }
        set {
            noteField.text = newValue
        }
    }
    
    var date: Date {
        get {
            datePicker.date
        }
        set {
            datePicker.setDate(newValue, animated: false)
        }
    }
    
    func saveToPhotos() {
//        if let imageToBeSaved{
//            UIImageWriteToSavedPhotosAlbum(imageToBeSaved, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
//        imageToBeSaved = nil
        
    }
    
    
    func dismissView() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String,message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    func openPhotoLibrary(selectionLimit: Int){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = selectionLimit
        
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
                displayImage(image: downsample(image: image)!)
                
                
//                let alert = UIAlertController(title: "Save Image", message: "Would you like to save the image to photos", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "No", style: .default))
//                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
////                    imageToBeSaved = image
//                    presenter?.optedToSaveCapturedImageToPhotos()
//
//                }))
//
//                present(alert, animated: true)
//
//
                
            }
            
            
            
            
        }
        picker.dismiss(animated: true)
    }
    
    
    
    
    func displayImage(image: UIImage){

        attachmentsVC.attachments.append(image.jpegData(compressionQuality: 1.0)!)

    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            let ac = UIAlertController(title: "Image was not saved to photos due to an error while saving", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
//            imageToBeSaved = nil
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
                print(url)
                let image = downsample(imageAt: url) ?? UIImage(systemName: "photo")
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
    func textFieldDidBeginEditing(_ textField: UITextField){
        textField.layer.borderColor = UIColor.systemGreen.cgColor

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemTeal.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch TextFieldTag(rawValue: textField.tag){
            
            
        case .none:
            return true
        case .some(let field):
            switch field{
            case .amount:
                
                
                return presenter?.shouldReplaceTextInAmountField(textPresent: textField.text ?? "",range: range ,incomingText: string) ?? true
            case .title:
                return true
            }
        }
       
    }
}


extension AddExpenseVC: UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.systemTeal.cgColor
    }
    
    
}





extension AddExpenseVC{
    
    
    func updateUserActivity(){
        print(#function)
        
        
        var activity = view.window?.windowScene?.userActivity
        if activity == nil{
            activity = NSUserActivity(activityType: SceneDelegate.MainSceneActivityType())
        }
        
//        var presentSaveImageToCamera = false
//        if imageToBeSaved != nil{
//            presentSaveImageToCamera = true
//        }
//
//        var attachments = [Data?]()
//
//        attachmentsVC.attachments.forEach { image in
////            let data = image.jpegData(compressionQuality: 1.0)
//            attachments.append(image)
//        }
//
        
//        let capturedImageData = imageToBeSaved?.jpegData(compressionQuality: 1.0)
        
        let entries: [AnyHashable : Any] = [
            StateRestorationConstants.presentedAddExpenseKey : true,
            StateRestorationConstants.amountKey : amountField.text as Any,
            StateRestorationConstants.titleKey : titleField.text as Any,
            StateRestorationConstants.attachmentsKey : attachmentsVC.attachments as Any,
            StateRestorationConstants.dateKey : datePicker.date,
            StateRestorationConstants.noteKey : noteField.text as Any,
            StateRestorationConstants.categoryKey : categoryBtn.title(for: .normal) as Any,
            StateRestorationConstants.expenseIDKey : expenseID as Any
//            StateRestorationConstants.capturedImageKey : capturedImageData as Any,
//            StateRestorationConstants.presentSaveImageToCameraAlertKey : presentSaveImageToCamera
            
        ]
        
        activity?.addUserInfoEntries(from: entries)
        
        
        view.window?.windowScene?.userActivity = activity
    }
    
    func restoreView(with values: [AnyHashable: Any]){
        
        print(#function)
        if let title = values[StateRestorationConstants.titleKey] as? String{
            titleField.text = title
        }
        if let date = values[StateRestorationConstants.dateKey] as? Date{
            datePicker.setDate(date, animated: false)
        }
        if let amount = values[StateRestorationConstants.amountKey] as?  String{
            amountField.text = amount
        }
        if let category = values[StateRestorationConstants.categoryKey] as? String{
            categoryBtn.setTitle(category, for: .normal)
        }
        if let note = values[StateRestorationConstants.noteKey] as? String{
            noteField.text =  note
        }
        if let attachments = values[StateRestorationConstants.attachmentsKey] as? [Data]{
            
//            attachments.forEach { data in
//                attachmentsVC.attachments.append(data!)
//            }
            attachmentsVC.attachments = attachments
            
        }
//        if let image = values[StateRestorationConstants.capturedImageKey] as? UIImage{
////            imageToBeSaved = image
//        }
        if let expenseID = values[StateRestorationConstants.expenseIDKey] as? String{
            self.expenseID = expenseID
            self.navTitle = "Edit Expense"
        }else{
            self.navTitle = "Add Expense"
        }
        
    }
    
    
    
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
        let table = UITableView(frame: .zero, style: .insetGrouped)
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









extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




