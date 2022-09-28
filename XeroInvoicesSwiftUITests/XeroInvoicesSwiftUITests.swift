//
//  XeroInvoicesSwiftUITests.swift
//  XeroInvoicesSwiftUITests
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import XCTest
@testable import XeroInvoicesSwiftUI

final class XeroInvoicesSwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddInvoiceLine() throws {
        var testInvoice: Invoice = Invoice(invoiceNumber: 1)
        XCTAssertTrue(testInvoice.lineItems.isEmpty)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 0)

        //Adding first product
        testInvoice.addInvoiceLine(InvoiceLine(product: .banana))
        XCTAssertTrue(testInvoice.lineItems.count == 1)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 1)

        //Adding another product
        testInvoice.addInvoiceLine(InvoiceLine(product: .blueberries))
        XCTAssertTrue(testInvoice.lineItems.count == 2)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 2)

        //Adding another product BUT the same as product 1
        testInvoice.addInvoiceLine(InvoiceLine(product: .banana))
        XCTAssertTrue(testInvoice.lineItems.count == 2)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 3)
    }
    
    func testRemoveInvoiceLine() throws {
        var testInvoice: Invoice = .example
        // There are 3 itemLines and totally 6 product pieces in the EXAMPLE
        XCTAssertTrue(testInvoice.lineItems.count == 3)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 6)
        
        //Removing blueberries which has 2 product pieces
        testInvoice.removeInvoiceLine(with: Product.blueberries.productId)
        XCTAssertTrue(testInvoice.lineItems.count == 2)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 4)
        
        //trying to Remove blueberries one more time - result should be the same as was above since no blueberries in the incoice anymore
        testInvoice.removeInvoiceLine(with: Product.blueberries.productId)
        XCTAssertTrue(testInvoice.lineItems.count == 2)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 4)
    }
    
    func testGetTotal() throws {
        var testInvoice: Invoice = Invoice(invoiceNumber: 1)
        var testCost: Double = 0
        let invoiceLine1 = InvoiceLine(product: .banana)
        XCTAssertTrue(invoiceLine1.quantity == 1) //checking the quantity quantity is 1
        XCTAssertTrue(invoiceLine1.cost == Product.banana.cost) //checking the quantity quantity is 1

        testInvoice.addInvoiceLine(invoiceLine1)
        testCost += invoiceLine1.cost
        
        let invoiceLine2 = InvoiceLine(product: .blueberries, quantity: 10)
        XCTAssertTrue(invoiceLine2.cost == (Product.blueberries.cost * 10)) //checking the quantity cost calculation
        testInvoice.addInvoiceLine(invoiceLine2)
        testCost += invoiceLine2.cost
        
        XCTAssertTrue(testCost == testInvoice.getTotal())
    }
    
    func testMergeInvoices() throws {
        var testInvoice1: Invoice = .example
        // There are 3 itemLines and totally 6 product pieces in the EXAMPLE
      
        let testInvoice2: Invoice = testInvoice1 // COPY
        testInvoice1.mergeInvoices(sourceInvoice: testInvoice2)
        
        XCTAssertTrue(testInvoice1.totalAmountOfProducts == testInvoice2.totalAmountOfProducts * 2, "totalAmountOfProducts should be x2")
        XCTAssertTrue(testInvoice1.getTotal() == testInvoice2.getTotal() * 2, "getTotal should be x2")
        XCTAssertTrue(testInvoice1.lineItems.count ==  testInvoice2.lineItems.count, "lineItems should be THE SAME")
        
        
        //Another scenario
        var test3:Invoice = .example
        XCTAssertFalse(test3.lineItems.contains(where: {$0.product == .orange}), "Should be NO ORANGES in .example")

        let productsBeforeMerging = test3.totalAmountOfProducts
        
        //Crearting a new invoice with oranges
        var test4 = Invoice(invoiceNumber: 1)
        test4.addInvoiceLine(InvoiceLine(product: .orange, quantity: 1))
        
        test3.mergeInvoices(sourceInvoice: test4)
        XCTAssertTrue(test3.lineItems.contains(where: {$0.product == .orange}),"Should has ORANGES in after merging")
        XCTAssertTrue(test3.totalAmountOfProducts == (productsBeforeMerging + 1),"Should has one more product after merging")
    }
    
    func testDeepCloning() throws {
        //Scanario1 - working with optionlas and nulls
        var test1:TestClass? = TestClass(id: 1, name: "My Name")
        XCTAssertNotNil(test1)
        
        let test2 = test1?.clone()
        XCTAssertNotNil(test2)
        XCTAssertTrue(test2?.name == "My Name")

        test1?.name = "My Another name"
        XCTAssertTrue(test1?.name == "My Another name")
        XCTAssertTrue(test2?.name == "My Name", "Should still be the same name as when cloned")
        
        //Killing orifinal reference
        test1 = nil
        XCTAssertNil(test1)
        XCTAssertNotNil(test2)
        XCTAssertTrue(test1?.name == nil)
        XCTAssertTrue(test2?.name != nil)
        XCTAssertTrue(test2?.name == "My Name")
        
        //Scanario2 - working with NON optionlas
        let test3 = TestClass(id: 2, name: "Scenario2")
        let test4 = test3.clone()
        XCTAssertTrue(test3.name == "Scenario2")
        XCTAssertTrue(test4.name == "Scenario2")
        
        test3.name = "Dmitrii"
        XCTAssertTrue(test3.name == "Dmitrii", "Should be updated")
        XCTAssertTrue(test4.name == "Scenario2", "Should be NOT updated")
    }
    
    func testOrderItems() {
        var testInvoice: Invoice = .example
        //the existing order is [.blueberries, .pizza, .banana]
        //adding missig .orange
        testInvoice.addInvoiceLine(InvoiceLine(product: .orange))
        XCTAssertTrue(testInvoice.lineItems.map({$0.product}) == [.blueberries, .pizza, .banana, .orange])
        
        let sortedProducts = testInvoice.orderLineItems()
        // sorted byID order should be:  [banana, blueberries, orange, pizza]
        XCTAssertTrue(sortedProducts.map({$0.product}) == [.banana, .blueberries, .orange, .pizza])
        //Checking by ID. That it's sorted properly
        let productIds = sortedProducts.map({$0.product.productId})
        XCTAssertTrue(productIds == productIds.sorted()) // same result as after .sorted()
    }
    
    func testPreviewLineItems() throws {
        let testInvoice: Invoice = .example
        // There are 3 itemLines and totally 6 product pieces in the EXAMPLE
        
        XCTAssertTrue(testInvoice.lineItems.count > 2) // checking that there are more than 2 lines before preview applied
        let previewLineItems = testInvoice.previewLineItems(2)
        XCTAssertTrue(previewLineItems.count == 2)
        
        XCTAssertTrue(testInvoice.previewLineItems(10).count <= 10)
        XCTAssertTrue(testInvoice.previewLineItems(1).count <= 1)
    }
    
    func testRemoveItems() throws {
        var testInvoice: Invoice = .example
        // There are 3 itemLines and totally 6 product pieces in the EXAMPLE
        XCTAssertTrue(testInvoice.lineItems.count == 3)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 6)

        let copy = testInvoice
        testInvoice.removeItems(from: copy)
        
        //Should be nothing in lineItems because the copy invoice has all the same items
        XCTAssertTrue(testInvoice.lineItems.isEmpty)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 0)
        
        //Manual scenario
        testInvoice = Invoice(invoiceNumber: 1)
        testInvoice.addInvoiceLine(InvoiceLine(product: .orange, quantity: 2))
        testInvoice.addInvoiceLine(InvoiceLine(product: .blueberries))
        testInvoice.addInvoiceLine(InvoiceLine(product: .banana))
        
        var testInvoice2 = Invoice(invoiceNumber: 1)
        testInvoice2.addInvoiceLine(InvoiceLine(product: .orange, quantity: 1))
        testInvoice2.addInvoiceLine(InvoiceLine(product: .blueberries))
        
        //Checikng preconditions
        XCTAssertTrue(testInvoice.lineItems.count == 3)
        XCTAssertTrue(testInvoice.totalAmountOfProducts == 4)
        
        XCTAssertTrue(testInvoice2.lineItems.count == 2)
        XCTAssertTrue(testInvoice2.totalAmountOfProducts == 2)
        
        testInvoice.removeItems(from: testInvoice2)

        XCTAssertTrue(testInvoice.lineItems.count == 2) // orange and banana
        XCTAssertTrue(Set(testInvoice.lineItems.map({$0.product})) == Set([.orange, .banana]))

        XCTAssertTrue(testInvoice.totalAmountOfProducts == 2) // 1 orange and 1 banana
    }

    func testToString() throws {
        var testInvoice = Invoice(invoiceNumber: 123)
        testInvoice.invoiceDate = Date.init(timeIntervalSince1970: 0)
        
        testInvoice.addInvoiceLine(InvoiceLine(product: .orange, quantity: 2))
        testInvoice.addInvoiceLine(InvoiceLine(product: .blueberries))
        testInvoice.addInvoiceLine(InvoiceLine(product: .banana))
        
        let expentingResult = "Invoice Number: 123, InvoiceDate: 01/01/1970, LineItemCount1: 3, LineItemCount2: 4"
        
        XCTAssertTrue(testInvoice.toString() == expentingResult, "Unexpected result: \(testInvoice.toString())")
    }
    
    func testLocalisation() throws {
        ContentViewStrings.allCases.forEach {
            XCTAssertTrue($0.localised != $0.rawValue)
            XCTAssertTrue($0.rawValue.localised != $0.rawValue)
            XCTAssertTrue($0.rawValue.localised == $0.localised)
        }
        
        InvoiceViewStrings.allCases.forEach {
            XCTAssertTrue($0.localised != $0.rawValue)
            XCTAssertTrue($0.rawValue.localised != $0.rawValue)
            XCTAssertTrue($0.rawValue.localised == $0.localised)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
