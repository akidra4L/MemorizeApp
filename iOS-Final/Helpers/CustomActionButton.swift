//
//  CustomActionButton.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 21.05.2023.
//

import UIKit

class CustomActionButton: UIButton {
    
    public var icon: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(icon: String) {
        self.init(frame: CGRect.zero)
        
        self.icon = icon
        self.layer.cornerRadius = 24
        
        
        if let icon = self.icon {
            self.setImage(UIImage(systemName: icon), for: .normal)
            self.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
