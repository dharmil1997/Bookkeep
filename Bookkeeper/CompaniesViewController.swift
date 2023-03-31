//
//  ViewController.swift
//  Bookkeeper
//
//

import UIKit


class CompaniesViewController: BaseViewController {
    
//    MARK:- VARIABLES DECLARATION
    var objectType = Company.self

//    MARK: - PLEASE DO NOT DELETE ANY CODE FROM THE SECTION BELOW
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    ///////////////////////END OF SECTION///////////////////////////////
    
    override func setupUI() {
        super.setupUI()
        let addCompanyButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOrEditItem))
        addCompanyButton.accessibilityIdentifier = Identifiers.addButton
        navigationItem.leftBarButtonItem = addCompanyButton

        loadItems(type: objectType)
    }

    override func setupTableView() {
        super.setupTableView()
        tableView.accessibilityIdentifier = Identifiers.companiesTableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.bottomAnchor.constraint(equalTo: logoImage.topAnchor, constant: -20).isActive = true
    }
    //MARK:- TASK 4
    // 4 - Fix the add or edit method to be able to add a new company or edit a company name at a given index
    // Please note that you should use an Alert Controller with a text field remember to add the
    // Identifiers.addCompanyTextField accessibilityIdentifier to the text field.
    // The title of the alert controller should be "Edit company name" if it is being edited and the textfield should contain the edited company name.
    // If new item is being added the allert controller's title should be "Add a company"
    // The alerts button should have a title "OK"

    
    @objc func addOrEditItem(isEditing: Bool = false, index: Int = 0) {
           let title = isEditing ? "Edit company name" : "Add a company"
           let message = isEditing ? "Please enter the new name for the company" : "Please enter the name for the new company"

           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

           alertController.addTextField { (textField) in
               textField.accessibilityIdentifier = Identifiers.addCompanyTextField
               textField.placeholder = "Company Name"
               textField.text = isEditing ? (self.itemArray[index] as! Company).name : ""
           }

           let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
               guard let companyName = alertController.textFields?[0].text, !companyName.isEmpty else { return }

               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let managedContext = appDelegate.coreDataStack.managedContext

               if isEditing {
                   // Update existing company
                   let company = self.itemArray[index] as! Company
                   company.name = companyName
               } else {
                   // Add new company
                   let company = Company(context: managedContext)
                   company.name = companyName
                   self.itemArray.append(company)
               }

               appDelegate.coreDataStack.saveContext()
               self.tableView.reloadData()
           }
           alertController.addAction(okAction)

           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)

           present(alertController, animated: true, completion: nil)
       }
    
    //MARK:- TABLEVIEW DELEGATE FUNCTIONS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let company = itemArray[indexPath.row] as! Company
        cell.textLabel?.text = company.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
        let selectedCompany = itemArray[indexPath.row] as! Company
        let vc = InvoicesViewController()
        vc.selectedCompany = selectedCompany
        tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }

    //MARK:- TableView Swipe actions
    override func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            
            self.addOrEditItem(isEditing: true, index: indexPath.row)
            
            completion(true)
        }
        
        action.backgroundColor = UIColor.blue
        
        return action
    }

    //MARK:- SEARCHBAR DELEGATE FUNCTIONS
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        print(textSearched)
        
        if searchBar.text?.count ?? 0 > 0 {
            
            let predicate: NSPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            
            loadItems(with: predicate, type: objectType)
        } else {
            loadItems(type: objectType)
        }
    }
}
