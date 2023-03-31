# Book Keeper Application

## Introduction

You are working for a software company as a Senior iOS Developer. You are taking over a project from a Junior Developer who definitely did not know what they was doing. The developer is completely unfamiliar with the D.R.Y. coding principle, therefore they have been using copy and paste very often. Your job is to create a core data stack and initialize it. Next, you need to refactor two viewControllers into one BaseViewController to minimize code repetition. Then, use it as a base Class for the two viewControllers to inherit from.
Performance is not an issue as there will never be more than 10 companies and 20 invoices per company in the database. However, please note that you are required to implement concurrency into the project. Saving should always happen in the background on a private queue.

## Task definition

**Note:** Please do NOT modify any tests unless specifically told to do so.
**Note:** Please do NOT modify the function declarations and return types. 

Your task is to implement the following features of the app:

1. Initialize the Core Data stack in the CoreDataStack.swift file by filling out the below:
`lazy var persistentContainer: NSPersistentContainer`

2. Fill out the Core Data Saving function below to allow for saving changes:
`func saveContext() -> CoreDataOperation`
it returns a CoreDataOperation object. It should call the completion handler with .success CoreDataOperation if saving has succeeded or with .failed if saving has failed.

3. Create a generic Core Data fetch request by filling out the function below:
`func fetchEntities<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T]?`

4. Create a method that allows for adding or editing an item by filling out the function below in the CompaniesViewController.swift:
`@objc func addOrEditItem(isEditing: Bool = false, index: Int = 0)`

For this purpose, use the AlertViewController with an added textField; just make sure it has the Enter company name placeholder.
Please note that the AlertViewController title should be 'Add a company' if it is a new entry and 'Edit company name' if the company is being edited. In addition, the textField should contain the company name if it is edited.

5. Create a method that allows for adding or editing an item by filling out the function below for an invoice in the InvoicesViewController.swift.
`@objc func addOrEditItem()`

Make sure that once an item has been added or edited the textFields will be reset to empty and the UISwitch will be set to off.

6. Refactor the two View Controllers into the BaseViewController.swift file by filling out the delete method in the BaseViewController:
`func deleteAction(at indexPath: IndexPath) -> UIContextualAction`

Make sure that deleting works for both Company and Invoice.
The invocation of the delete action should display an alert controller with two buttons, i.e. "Delete" and "Cancel". Make sure both of them work.


# Hints

* For all tests to pass, please do not add any company or invoice name that contains the letter 'S'.

* In task No. 4, make sure that only valid entries can be added, i.e. the company name cannot be empty.

* In task No. 5, same as above is applicable. The entry needs to be valid. 

* Remember that the itemArray needs to be casted as either Company or Invoice entity, depending on which ViewController you are in.

* You can use the String extension from SupportingFiles to check if a String is really empty.

* Think about invalid input calls for your app. 
