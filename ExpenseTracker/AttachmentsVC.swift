//
//  AttachmentsVC.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 02/02/23.
//

import UIKit

protocol AttachmentsVCDelegate: NSObject{
    
    
   
    
    
    
}












class AttachmentsVC: UIViewController{
    
    
    var attachments = [Data](){
        didSet{
            print(attachments)
            DispatchQueue.main.async {[weak self] in
                self?.collectionView.reloadData()
                self?.hasNoAttachments = self?.attachments.count == 0 ? true : false
            }
        }
    }
    
    var hasNoAttachments = true{
        didSet{
            if hasNoAttachments{
                view.isHidden = true
            }else{
                view.isHidden = false
            }
        }
    }
    
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
    
    override func viewDidLoad() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        view.addSubview(collectionView)
        collectionView.pinToSafeArea(view: view)
        view.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(AttachmentCell.self, forCellWithReuseIdentifier: AttachmentCell.reuseID)
        
        hidesBottomBarWhenPushed = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if hasNoAttachments{
            view.isHidden = true
        }else{
            view.isHidden = false
        }
    }
    
    
    
    private static func getLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
}

extension AttachmentsVC: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SlideShowVCDelegate {
    func image(for indexPath: IndexPath) -> UIImage {
        downsample(imageData: attachments[indexPath.row])!
    }
    
    func noOfImages() -> Int {
        attachments.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachmentCell.reuseID, for: indexPath) as! AttachmentCell
        
        cell.imageView.image = downsample(imageData: attachments[indexPath.row])!
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            configureContextMenu(index: indexPath)
        }
     
    func configureContextMenu(index: IndexPath) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                self.attachments.remove(at: index.row)
                self.collectionView.deleteItems(at: [index])
            }
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
        }
        return context
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SlideShowViewController()
        vc.delegate = self
        vc.selectedIndex = indexPath
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
//        navigationController?.pushViewController(vc, animated: true)
        self.present(navVC, animated: true)
    }
    
    
    
    
}


class AttachmentCell: UICollectionViewCell{
    
    static let reuseID = "Attachment cell"
    
    
    lazy var imageView={
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configView(){
        contentView.addSubview(imageView)

        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}




class SlideShowViewController: UIViewController{

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout1())
    
    weak var delegate: SlideShowVCDelegate?
    

    var selectedIndex: IndexPath = .init(row: 0, section: 0){
        didSet{
            needsToScroll = true
        }
    }

    private var needsToScroll = false

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configCollectionView()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
                        [weak self] in
                        self?.collectionView.scrollToItem(at: self?.selectedIndex ?? .init(row: 0, section: 0), at: .centeredHorizontally, animated: false)
                    }

}


    private func configCollectionView(){

        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        view.addSubview(collectionView)
//        hidesBottomBarWhenPushed = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(dismissView))

        collectionView.register(FullImageCell.self, forCellWithReuseIdentifier: FullImageCell.reuseID)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)

        ])


    }
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
}






protocol SlideShowVCDelegate: NSObject{
    
    
    func image(for indexPath: IndexPath) -> UIImage
    
    func noOfImages()->Int
    
    
}










extension SlideShowViewController:UICollectionViewDelegate,UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true)
        print(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullImageCell.reuseID, for: indexPath) as! FullImageCell
        cell.imageView.contentMode = .scaleAspectFit

        
        cell.imageView.image = delegate?.image(for: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.noOfImages() ?? 0
    }

    private static func createLayout1()->UICollectionViewLayout{


        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))



        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .groupPagingCentered
        

        section.interGroupSpacing = 30

        let layout =  UICollectionViewCompositionalLayout(section: section)


        return layout
    }



    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
                if let index = collectionView.indexPathForItem(at: view.center){
                    selectedIndex = index
                }
                if needsToScroll{
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.collectionView.scrollToItem(at: self?.selectedIndex ?? .init(row: 0, section: 0), at: .centeredHorizontally, animated: false)
                    }
                }

                collectionView.collectionViewLayout.invalidateLayout()
       
            
    }
     
}



class FullImageCell: UICollectionViewCell{

    var reuseCellHelperID: String = ""
    static let reuseID = "FullImageCell"
    lazy var imageView={
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
//        imageView.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)


        configView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView(){
        contentView.addSubview(imageView)
//      contentView.backgroundColor = .white
//        imageView.layer.borderWidth = 0.5
//        imageView.layer.cornerRadius = 15
//        imageView.clipsToBounds = true
////        imageView.layer.borderColor = UIColor.black.cgColor
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}





