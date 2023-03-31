//
//  InvoicesViewController.swift
//  Bookkeeper
//
//

import UIKit
import CoreData

class InvoicesViewController: BaseViewController, UITextFieldDelegate {

    //MARK:- VARIABLES DECLARATION
    let objectType = Invoice.self
    
    var selectedCompany: Company? {
        didSet {
            loadItems(type: objectType)
            print("THE COMPANY IS \(selectedCompany!.name!)")
        }
    }
    
    var isEditingObject = false
    var currentIndex = 0
    
    //MARK:- NEW INVOICE ENTRY FIELDS - EXTRACTED TO InvoiceAddEditView.swift in SupportingFiles
    let addInvoiceView = InvoiceAddEditView()
    
    
    //MARK: - PLEASE DO NOT DELETE ANY CODE FROM THE SECTION BELOW///
    override func viewDidLoad() {                                  //
        super.viewDidLoad()                                        //
    }                                                              //
    ////////////////////// END OF SECTION ///////////////////////////
    
   override func setupUI() {
        super.setupUI()
        setupAddInvoiceView()
        
        loadItems(type: objectType)
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.accessibilityIdentifier = Identifiers.invoicesTableView
        tableView.register(InvoicesTableViewCell.self, forCellReuseIdentifier: InvoicesTableViewCell.CELL_ID)
    }
    
    func setupAddInvoiceView() {
        addInvoiceView.invAmountTextField.delegate = self
        addInvoiceView.invSaveButton.addTarget(self, action: #selector(addOrEditItem), for: .touchUpInside)
        
        view.addSubview(addInvoiceView)
        addInvoiceView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8).isActive = true
        addInvoiceView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        addInvoiceView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addInvoiceView.bottomAnchor.constraint(equalTo: logoImage.topAnchor, constant: -30).isActive = true
    }
   
    //MARK: - TASK 5
    //5 - Create a method which allows adding or editing an invoice by filling out the method below.
    //Make sure that once an item has been added or edited the textFields should be reset to empty and the UISwitch should be set to off.
    @objc func addOrEditItem() {
     
    }
    
    //MARK:- CORE DATA MANIPULATION FUNCTIONS
    override func loadItems<T: NSManagedObject>(with predicate: NSPredicate? = nil, type: T.Type) {
        let newPredicate: NSPredicate
        let companyPredicate = NSPredicate(format: "parentCompany.name MATCHES %@", selectedCompany!.name!)
        
        if let passedInPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [companyPredicate, passedInPredicate])
            newPredicate = compoundPredicate
        } else {
            newPredicate = companyPredicate
        }
        
        let sortByNumber = NSSortDescriptor(key: "number", ascending: true)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sortDescriptors = [sortByNumber, sortByTitle]
        
        
        guard let fetchResult = CoreDataStack.shared.fetchEntities(entity: objectType, predicate: newPredicate, sortDescriptors: sortDescriptors) else { return }
        itemArray = fetchResult
        tableView.reloadData()
    }
    
    //MARK:- TABLEVIEW DELEGATE FUNCTIONS
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvoicesTableViewCell.CELL_ID, for: indexPath) as! InvoicesTableViewCell
        guard let invoice = itemArray[indexPath.row] as? Invoice else { return cell }
        
        let number = invoice.number
        let title = invoice.title
        let amount = invoice.amount
        let paid = invoice.paid
        
        cell.numberLabel.text = "\(number)"
        cell.nameLabel.text = "\(title ?? "Not entered")"
        cell.amountLabel.text = "\(amount)"
        cell.accessoryType = paid ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
        let invoice = itemArray[indexPath.row] as! Invoice
        invoice.paid = !invoice.paid
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- TableView Swipe actions
    
    override func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            
            self.isEditingObject = true
            self.currentIndex = indexPath.row
            let objectToEdit = self.itemArray[self.currentIndex] as! Invoice
            self.addInvoiceView.invNumberTextField.text = "\(objectToEdit.number)"
            self.addInvoiceView.invTitleTextField.text = "\(objectToEdit.title ?? "")"
            self.addInvoiceView.invAmountTextField.text = "\(objectToEdit.amount)"
            self.addInvoiceView.invPaidSwitch.isOn = objectToEdit.paid
            
            completion(true)
        }
        
        action.backgroundColor = UIColor.blue
        
        return action
    }
    
    //MARK:- SEARCHBAR DELEGATE FUNCTIONS
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        
        if searchBar.text?.count ?? 0 > 0 {
            print(textSearched)

            let predicate: NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            loadItems(with: predicate, type: objectType)
        } else {
            loadItems(type: objectType)
        }
    }
    

    //MARK:- TEXT FIELD DELEGATE
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return false
        }
        
        if textField.tag == 1 {
            let newText = oldText.replacingCharacters(in: range, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
        return true
    }

}
