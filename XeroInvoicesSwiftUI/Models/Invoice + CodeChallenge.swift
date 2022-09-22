//
//  Invoice + CodeChallenge.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import Foundation

// CODE CHALLENGE TASKS - Everything is covered in UniTests

extension Invoice {
    mutating func addInvoiceLine(_ line: InvoiceLine) {
        if let index = lineItems.firstIndex(where: {$0.product.productId == line.product.productId}) {
            lineItems[index].quantity += line.quantity
        } else{
            lineItems.append(line)
        }
    }
    
    mutating func removeInvoiceLine(with id: Int) {
        guard let index = lineItems.firstIndex(where: {$0.product.productId == id})  else { return }
        lineItems.remove(at: index)
    }
    
    /// GetTotal should return the sum of (Cost * Quantity) for each line item
    func getTotal() -> Double {
        lineItems.map{ $0.cost }.reduce(0, +)
    }
    
    /// MergeInvoices appends the items from the sourceInvoice to the current invoice
    mutating func mergeInvoices(sourceInvoice: Invoice) {
        sourceInvoice.lineItems.forEach { self.addInvoiceLine($0) }
    }
    
    /*
            /// Creates a deep clone of the current invoice (all fields and properties)
         func clone() -> Invoice {
                I've decided not to use Class but scruct. So no need for this because you can just use:
                let invoice1 = Invoice(invoiceNumber: 1)
                let invoice2 = invoice1
     
     However, if you're curious if I know how to do deep cloning - please check the functionality is implemented in NSCopying+Ext.swift file and covered in unit tests
     
         }
     */
    

    /// order the lineItems by Id
    func orderLineItems() -> [InvoiceLine] {
        lineItems.sorted(by: {$0.product.productId < $1.product.productId})
    }
    
    /// returns the number of the line items specified in the variable `max`
    func previewLineItems(_ max: Int) -> [InvoiceLine] {
        Array(lineItems.prefix(max))
    }
    
    /// remove the line items in the current invoice that are also in the sourceInvoice
    mutating func removeItems(from sourceInvoice: Invoice) {
        sourceInvoice.lineItems.forEach { invoiceLine in
            if let index = self.lineItems.firstIndex(where: {$0.product == invoiceLine.product}) {
                if lineItems[index].quantity <= invoiceLine.quantity {
                    lineItems.remove(at: index)
                } else {
                    lineItems[index].quantity -= invoiceLine.quantity
                }
            }
        }
    }
    
    /// Outputs string containing the following (replace [] with actual values):
    /// Invoice Number: [InvoiceNumber], InvoiceDate: [DD/MM/YYYY], LineItemCount: [Number of items in LineItems]
    ///
    func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        
        /*
         OK I was not sure what exactly you ask for LineItemCount
         so I added both:
             number of lineitems(1) and amount of all the items(2) in the invoice
         */
        
        return [
            "Invoice Number: \(invoiceNumber)",
            "InvoiceDate: \(df.string(from: invoiceDate))",
            "LineItemCount1: \(lineItems.count)",
            "LineItemCount2: \(totalAmountOfProducts)"
        ].joined(separator: ", ")
    }
}
