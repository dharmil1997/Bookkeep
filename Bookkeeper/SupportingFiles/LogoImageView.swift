//
//  LogoImageView.swift
//  Bookkeeper
//
//

import UIKit

class LogoImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLogo() {
        image = UIImage(named: "logo")
        contentMode = .scaleAspectFit
        
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        bottomAnchor.constraint(equalTo: superview?.bottomAnchor ?? super.bottomAnchor, constant: -30).isActive = true
        leftAnchor.constraint(equalTo: superview?.leftAnchor ?? super.leftAnchor, constant: 10).isActive = true
        rightAnchor.constraint(equalTo: superview?.rightAnchor ?? super.rightAnchor, constant: -10).isActive = true
    }
    
    
}
