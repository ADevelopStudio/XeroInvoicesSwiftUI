//
//  Mocks.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import Foundation

extension Invoice {
    static var example: Invoice {
        var invoice = Invoice(invoiceNumber: 123)
        invoice.addInvoiceLine(InvoiceLine(product: .blueberries))
        invoice.addInvoiceLine(InvoiceLine(product: .blueberries))
        invoice.addInvoiceLine(InvoiceLine(product: .pizza))
        invoice.addInvoiceLine(InvoiceLine(product: .banana, quantity: 3))
        return invoice
    }
}
