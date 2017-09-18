//
//  Extensions.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-18.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Create snapshot
    ///
    /// - parameter rect: The `CGRect` of the portion of the view to return. If `nil` (or omitted),
    ///                   return snapshot of the whole view.
    ///
    /// - returns: Returns `UIImage` of the specified portion of the view.
    
    func snapshot(of rect: CGRect? = nil) -> UIImageView? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect else { return nil }
        
        // otherwise, grab specified `rect` of image
        
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
