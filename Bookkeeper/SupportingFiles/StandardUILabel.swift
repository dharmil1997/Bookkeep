//
//  StandardUILabel.swift
//  Bookkeeper
//
//

import UIKit

class StandardUILabel: UILabel {

    init(alignment: NSTextAlignment = .left, multiLine: Bool = false) {
        super.init(frame: .zero)
        textColor = .black
        textAlignment = alignment
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = multiLine ? 0 : 1
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
