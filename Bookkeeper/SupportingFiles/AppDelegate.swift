//
//  AppDelegate.swift
//  Bookkeeper
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let sampleInvoices: [(Int64, String?, Double, Bool)] = [
        (2, "Test 2", 100.13, false),
        (3, "Test 3", 111.14, true),
        (4, "Tost 4", 134.56, false),
        (5, "Tost 5", 32.33, true),
        (6, "Test 6", 789.99, false)
    ]


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if CommandLine.arguments.contains("--UITests") {
            UIView.setAnimationsEnabled(false)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: CompaniesViewController())
        
        
        if CoreDataStack.shared.persistentContainer.persistentStoreCoordinator.persistentStores.count > 0 {
            let predicate = NSPredicate(format: "name CONTAINS[cd] 's'")
            deleteData(entityName: "Company", predicate: predicate)
            
            let addedSampleCompanies = addSampleData()
            let addedSampleInvoices = addSkillerCompanyWithInvoice(addMoreInvoices: true)
        
            print("SAMPLE COMPANIES ADDING: \(addedSampleCompanies)")
            print("SAMPLE INVOICES ADDING: \(addedSampleInvoices)")

        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        _ = CoreDataStack.shared.saveContext()
    }
    
    func addSampleData() -> CoreDataOperation {
        var outcome: CoreDataOperation = .failed
        let companyNames = ["Super Co.", "Second to None Co.", "Fascinating Co.","Sumup Co"]
        for company in companyNames {
            let newCompany = Company(context: CoreDataStack.shared.managedContext)
            newCompany.name = company
        }
        outcome = CoreDataStack.shared.saveContext()
        return outcome
    }
    
    func deleteData(entityName: String, predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataStack.shared.managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func addSkillerCompanyWithInvoice(addMoreInvoices: Bool = false) -> CoreDataOperation {
        let newCompany = Company(context: CoreDataStack.shared.managedContext)
        newCompany.name = "SkillerWithInvoice"
        
        let invoice = Invoice(context: CoreDataStack.shared.managedContext)
        invoice.number = 1
        invoice.title = "Test Invoice"
        invoice.amount = 232.15
        invoice.parentCompany = newCompany
        
        if addMoreInvoices {
            for invoice in sampleInvoices {
                print("Adding more")
                let inv = Invoice(context: CoreDataStack.shared.managedContext)
                inv.number = invoice.0
                inv.title = invoice.1
                inv.amount = invoice.2
                inv.paid = invoice.3
                inv.parentCompany = newCompany
            }
        }
        
        return CoreDataStack.shared.saveContext()
    }
}

