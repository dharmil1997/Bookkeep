//
//  BookkeeperUITests.swift
//  BookkeeperUITests
//
//

import XCTest

class BookkeeperUITests: XCTestCase {

    var app: XCUIApplication!
    var companiesTableView: XCUIElement!
    var invoicesTableView: XCUIElement!
    var addButton: XCUIElement!
    var searchButton: XCUIElement!
    var editAction: XCUIElement!
    var deleteAction: XCUIElement!
    var searchBar: XCUIElement!
    var okButton: XCUIElement!
    var deleteButton: XCUIElement!
    var addCompanyTextField: XCUIElement!
    var invoiceNumberField: XCUIElement!
    var invoiceTitleField: XCUIElement!
    var invoiceAmountField: XCUIElement!
    var invoicePaidSwitch: XCUIElement!

    override func setUp() {
        app = XCUIApplication()
        companiesTableView = app.tables[Identifiers.companiesTableView]
        invoicesTableView = app.tables[Identifiers.invoicesTableView]
        addButton = app.navigationBars.buttons[Identifiers.addButton]
        searchButton = app.navigationBars.buttons[Identifiers.searchButton]
        searchBar = app.searchFields["Search"]
        editAction = app.buttons["Edit"]
        deleteAction = app.buttons["Delete"]
        okButton = app.alerts.buttons["OK"]
        deleteButton = app.alerts.buttons["Delete"]
        addCompanyTextField = app.textFields[Identifiers.addCompanyTextField]
        invoiceNumberField = app.textFields[Identifiers.invoiceNumberTextField]
        invoiceTitleField = app.textFields[Identifiers.invoiceTitleTextField]
        invoiceAmountField = app.textFields[Identifiers.invoiceAmountTextField]
        invoicePaidSwitch = app.switches[Identifiers.invoicePaidSwitch]
        continueAfterFailure = false
        app.launchArguments.append("--UITests")
        app.launch()
    }
    
    override func tearDown() {
        companiesTableView = nil
        invoicesTableView = nil
        addButton = nil
        searchButton = nil
        searchBar = nil
        editAction = nil
        deleteAction = nil
        okButton = nil
        deleteButton = nil
        addCompanyTextField = nil
        invoiceNumberField = nil
        invoiceTitleField = nil
        invoiceAmountField = nil
        invoicePaidSwitch = nil
        app = nil
        super.tearDown()
    }
    
    func tapAlertButtonWith(title: String) {
        let button = app.alerts.buttons[title]
        
        if button.waitForExistence(timeout: 2) {
            button.tap()
        } else {
            XCTFail()
        }
    }
   
    // - 4
    func test_addCompany() {
        var countBeforeAdding = companiesTableView.cells.count
        
        if companiesTableView.cells.staticTexts["Devskiller Test"].exists {
            companiesTableView.cells.staticTexts["Devskiller Test"].firstMatch.swipeLeft()
            deleteAction.tap()
            
            deleteButton.tap()
            countBeforeAdding -= 1
        }
        
        addButton.tap()
        
        XCTAssertTrue(app.alerts.staticTexts["Add a company"].exists, "'Add a company' alert title missing")
        
        addCompanyTextField.tap()
        addCompanyTextField.typeText("Devskiller Test")
        
        tapAlertButtonWith(title: "OK")
        
        XCTAssertEqual(companiesTableView.cells.count, countBeforeAdding + 1)
    }
    
    func test_swipeToEdit_companyItem() {
        if companiesTableView.cells.count == 0 {
            addButton.tap()
            
            addCompanyTextField.tap()
            addCompanyTextField.typeText("Devskiller Test")

            okButton.tap()
        }
        
        companiesTableView.cells.firstMatch.swipeRight()
        editAction.tap()
        
        XCTAssertTrue(app.alerts.staticTexts["Edit company name"].exists, "'Edit company name' alert title missing")
        
        addCompanyTextField.tap()
        addCompanyTextField.typeText(" Edited")
        
        okButton.tap()
        
        let predicate = NSPredicate(format: "label CONTAINS[c] 'Edited'")
        let editedExists = app.staticTexts.containing(predicate).element.exists
        XCTAssertTrue(editedExists, "Editing failed")
    }
    
    // - 6
    func test_swipeToDelete_companyItem() {
        let countBeforeDeleting = companiesTableView.cells.count
        
        companiesTableView.cells.firstMatch.swipeLeft()
        
        deleteAction.tap()
        
        tapAlertButtonWith(title: "Delete")
        
        XCTAssertEqual(companiesTableView.cells.count, countBeforeDeleting - 1)
    }
    
    func test_invoicesVisible() {
        companiesTableView.cells.staticTexts["SkillerWithInvoice"].tap()
        
        XCTAssertEqual(invoicesTableView.cells.count, 6, "Invoice showing failed")
    }
    
    // - 5
    func test_swipeToEdit_invoiceItem() {
        companiesTableView.cells.staticTexts["SkillerWithInvoice"].tap()
        
        invoicesTableView.cells.firstMatch.swipeRight()
        editAction.tap()
        
        XCTAssertEqual(invoiceNumberField.value as? String, "1", "Invoice number editing failed")
        XCTAssertEqual(invoiceTitleField.value as? String, "Test Invoice", "Invoice title editing failed")
        XCTAssertEqual(invoiceAmountField.value as? String, "232.15", "Invoice value editing failed")
        XCTAssertEqual(invoicePaidSwitch.value as? String, "0", "Invoice isPaid editing failed")
        
        invoiceTitleField.tap()
        invoiceTitleField.typeText(" Edited")
        invoicesTableView.tap()
        
        app.buttons[Identifiers.saveInvoiceButton].tap()
        
        XCTAssertTrue(invoicesTableView.cells.staticTexts["Test Invoice Edited"].exists, "Editing failed")
    }
    
    
    // - 6
    func test_swipeToDelete_invoice() {
        companiesTableView.cells.staticTexts["SkillerWithInvoice"].tap()
        
        let countBeforeDeleting = invoicesTableView.cells.count
        
        invoicesTableView.cells.firstMatch.swipeLeft()
        deleteAction.tap()
  
        tapAlertButtonWith(title: "Delete")
        
        XCTAssertEqual(invoicesTableView.cells.count, countBeforeDeleting - 1)
    }

}
