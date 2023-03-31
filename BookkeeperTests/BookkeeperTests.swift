//
//  BookkeeperTests.swift
//  BookkeeperTests
//
//

import XCTest
import CoreData

@testable import Bookkeeper

class BookkeeperTests: XCTestCase {
    
    var sut: CoreDataStack?
    var companies: [Company]?
    var invoices: [Invoice]?

    override func setUp() {
        super.setUp()
        
        sut = CoreDataStack.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func deleteData(entityName: String, predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try sut?.managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteCompaniesWithName(containing: String) {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", containing)
        deleteData(entityName: "Company", predicate: predicate)
    }
    
    func addSkillerCompanyWithInvoice() -> CoreDataOperation {
        let newCompany = Company(context: sut!.managedContext)
        newCompany.name = "SkillerWithInvoice"
        
        let invoice = Invoice(context: sut!.managedContext)
        invoice.number = 1
        invoice.title = "Test Invoice"
        invoice.amount = 232.15
        invoice.parentCompany = newCompany
        
        return sut!.saveContext()
    }
    
    // - 1
    func test_setup_coreDataStackInitialized() {
        XCTAssertEqual(self.sut?.persistentContainer.persistentStoreCoordinator.persistentStores.count, 1, "Initialization of core data stack failed")
    }
    
    // - 2
    func test_addCompany() {
        deleteCompaniesWithName(containing: "Devskiller")

        let newCompany = Company(context: sut!.managedContext)
        newCompany.name = "Devskiller"
        XCTAssertEqual(sut?.saveContext(), .success, "Error saving company")
    }
    
    func test_addInvoice() {
        deleteCompaniesWithName(containing: "SkillerWithInvoice")

        XCTAssertEqual(addSkillerCompanyWithInvoice(), .success, "Error saving company and invoice")
    }
    
    // - 3
    func test_fetching_companyEntitiesFromDatabase() {
        let predicate = NSPredicate(format: "name CONTAINS[cd] 'SsssTEST'")
        deleteData(entityName: "Company", predicate: predicate)
        
        let newCompany = Company(context: sut!.managedContext)
        newCompany.name = "SsssTEST"
        XCTAssertEqual(sut?.saveContext(), .success, "Error saving company")

        companies?.removeAll()
        companies = CoreDataStack.shared.fetchEntities(entity: Company.self, predicate: predicate)
        XCTAssertNotNil(companies)
        XCTAssertEqual(companies?.count, 1, "Error fetching data from context")
    }
    

}
