//
//  Helpers.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 15/02/23.
//

import UIKit


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
    func pinToSafeArea(view: UIView){
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        
        ])
    }
}







func downsample(imageAt imageURL: URL,
                to pointSize: CGSize = .init(width: 200, height: 200),
                scale: CGFloat = UIScreen.main.scale) -> UIImage? {
    
    // Create an CGImageSource that represent an image
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
        print("source error")
        return nil
    }
    
    // Calculate the desired dimension
//    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    
    // Perform downsampling
    let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: 2_000
    ] as CFDictionary
    
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
        print("down sampling error")
        return nil
    }
    
    // Return the downsampled image as UIImage
    return UIImage(cgImage: downsampledImage)
}

//    lazy var noteField = {
//        let note = UITextField()
//        note.translatesAutoresizingMaskIntoConstraints = false
//        note.font = .systemFont(ofSize: 20)
//        note.textColor = .label
//        note.placeholder = "Note"
//        note.borderStyle = .roundedRect
//        note.textAlignment = .left
//        note.delegate = self
//        note.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        note.layer.cornerRadius = 5
//        note.layer.borderWidth = 1
//        note.layer.borderColor = UIColor.placeholderText.cgColor
//        return note
//    }()
