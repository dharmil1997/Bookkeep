//
//  BaseViewController.swift
//  Bookkeeper
//
//

import UIKit
import CoreData

class BaseViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let context = CoreDataStack.shared.managedContext
    
    var itemArray = [NSManagedObject]()
    
    let tableView = UITableView()
    
    //MARK: - PLEASE DO NOT DELETE ANY CODE FROM THE SECTION BELOW////////////////////////
    let logoImage = LogoImageView()                                                     //
                                                                                        //
    override func viewDidLoad() {                                                       //
        super.viewDidLoad()                                                             //
        hideKeyboardWhenTappedAround()                                                  //
        view.backgroundColor = .darkGray                                                //
        view.addSubview(logoImage)                                                      //
        logoImage.setupLogo()                                                           //
                                                                                        //
        setupUI()                                                                       //
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))//TO DELETE
    }                                                                                   //
    ///////////////////////////END OF SECTION/////////////////////////////////////////////
    func setupUI() {
        title = "BOOK KEEPER"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(activateSearchBar))
        searchButton.accessibilityIdentifier = Identifiers.searchButton
        navigationItem.rightBarButtonItem = searchButton
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    @objc func activateSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    //MARK:- CORE DATA MANIPULATION FUNCTIONS
    
    func loadItems<T: NSManagedObject>(with predicate: NSPredicate? = nil, type: T.Type) {
        guard let fetchResult = CoreDataStack.shared.fetchEntities(entity: type, predicate: predicate) else { return }
        itemArray = fetchResult
        tableView.reloadData()
    }
    
    func saveItems(reloadTableView: Bool = true){
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        if reloadTableView {
            tableView.reloadData()
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let object = itemArray[indexPath.row]
        context.delete(object)
        itemArray.remove(at: indexPath.row)
        
        saveItems(reloadTableView: false)
    }
    
    //MARK:- TABLEVIEW DELEGATE FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //MARK:- TableView Swipe actions
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction()
    }
    
    //MARK: - TASK 6
    //6b - Fillout the function below to create an universal delete swipe action for both view controllers
    //Please note that invoking the delete action should display an alert controller with "Delete" and "Cancel" buttons respectively please make sure that both of the buttons work.
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        
        return UIContextualAction()
    }
    
    
    //MARK:- SEARCHBAR DELEGATE FUNCTIONS
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
    }
}
