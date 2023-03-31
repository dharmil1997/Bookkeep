//
//  InvoicesTableViewCell.swift
//  Bookkeeper
//
//

import UIKit

class InvoicesTableViewCell: UITableViewCell {
    
    static let CELL_ID = "InvoiceCell"
    
    let numberLabel = StandardUILabel(alignment: .right)
    let nameLabel = StandardUILabel(multiLine: true)
    let amountLabel = StandardUILabel(alignment: .right)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        addSubview(numberLabel)
        addSubview(nameLabel)
        addSubview(amountLabel)
        
        numberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        numberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: numberLabel.rightAnchor, constant: 15).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        amountLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 15).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
