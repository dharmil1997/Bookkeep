//
//  InvoiceAddEditView.swift
//  Bookkeeper
//
//  Created by verebes on 03/06/2019.
//  Copyright © 2019 David V. All rights reserved.
//

import UIKit

class InvoiceAddEditView: UIView {

    let invNumberTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.keyboardType = .numberPad
        txtField.clearsOnBeginEditing = false
        txtField.placeholder = "No."
        txtField.backgroundColor = .lightGray
        txtField.accessibilityIdentifier = Identifiers.invoiceNumberTextField
        return txtField
    }()
    
    let invTitleTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.clearsOnBeginEditing = false
        txtField.placeholder = "Enter invoice details..."
        txtField.backgroundColor = .lightGray
        txtField.accessibilityIdentifier = Identifiers.invoiceTitleTextField
        return txtField
    }()
    
    let invAmountTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.keyboardType = .decimalPad
        txtField.clearsOnBeginEditing = false
        txtField.tag = 1
        txtField.placeholder = "Price"
        txtField.backgroundColor = .lightGray
        txtField.accessibilityIdentifier = Identifiers.invoiceAmountTextField
        return txtField
    }()
    
    let invPaidSwitch: UISwitch = {
        let swtch = UISwitch()
        swtch.translatesAutoresizingMaskIntoConstraints = false
        swtch.onTintColor = .blue
        swtch.accessibilityIdentifier = Identifiers.invoicePaidSwitch
        return swtch
    }()
    
    let invSaveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SAVE", for: .normal)
//        btn.addTarget(self, action: #selector(addOrEditItem), for: .touchUpInside)
        btn.backgroundColor = .blue
        btn.setTitleColor(.white, for: .normal)
        btn.accessibilityIdentifier = Identifiers.saveInvoiceButton
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(invNumberTextField)
        addSubview(invTitleTextField)
        addSubview(invAmountTextField)
        addSubview(invPaidSwitch)
        addSubview(invSaveButton)
        
        invNumberTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        invNumberTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        invNumberTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        invTitleTextField.topAnchor.constraint(equalTo: invNumberTextField.bottomAnchor, constant: 8).isActive = true
        invTitleTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        invTitleTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        invAmountTextField.topAnchor.constraint(equalTo: invTitleTextField.bottomAnchor, constant: 8).isActive = true
        invAmountTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        invAmountTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        invPaidSwitch.topAnchor.constraint(equalTo: invAmountTextField.bottomAnchor, constant: 8).isActive = true
        invPaidSwitch.centerXAnchor.constraint(equalTo: invAmountTextField.centerXAnchor, constant: -60).isActive = true
        
        invSaveButton.topAnchor.constraint(equalTo: invAmountTextField.bottomAnchor, constant: 8).isActive = true
        invSaveButton.centerXAnchor.constraint(equalTo: invAmountTextField.centerXAnchor, constant: 60).isActive = true
        
        heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
}
