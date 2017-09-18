//
//  Extensions.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-18.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

extension UIView {
    
    func snapshot(of rect: CGRect? = nil) -> UIImageView? {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        guard let image = wholeImage, let rect = rect else { return nil }
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        let screenshot = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
        let view = UIImageView(frame: rect)
        view.image = screenshot
        return view
    }
    
}



extension UIImageView {
    
    convenience init(baseImageView: UIImageView, frame: CGRect) {
        self.init(frame: CGRect.zero)
        
        image = baseImageView.image
        contentMode = baseImageView.contentMode
        clipsToBounds = true
        self.frame = frame
    }
}


extension UILabel {
    
    public class func size(withText text: String, forWidth width: CGFloat, withFont font: UIFont) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.font = font
        measurementLabel.text = text
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
}

}
