//
//  Invoice.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import Foundation
import Combine

struct Invoice: Hashable{    
    var invoiceNumber: Int
    var invoiceDate: Date
    var lineItems: [InvoiceLine] = []
    
    
    init(invoiceNumber: Int) {
        self.invoiceNumber = invoiceNumber
        self.lineItems = []
        self.invoiceDate = .now
    }
}

extension Invoice {
    var createdAt: String {
        Utilites.mediumDateFormatter.string(from: invoiceDate)
    }
    
    var totalAmountOfProducts: Int {
        lineItems.map{ $0.quantity }.reduce(0, +)
    }
    
    var totalCost: String {
        self.getTotal().inLocalCurrency
    }
    
    mutating func deleteInvoiceLine(at offsets: IndexSet) {
        lineItems.remove(atOffsets: offsets)
    }
}
