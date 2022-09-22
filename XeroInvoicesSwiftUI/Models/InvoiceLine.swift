//
//  InvoiceLine.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import Foundation

struct InvoiceLine: Hashable {
    var product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int = 1) {
        self.product = product
        self.quantity = quantity
    }
}

extension InvoiceLine {
    var cost: Double {
        (product.cost * Double(quantity))
    }
    
    var costBreakDown: String {
        [
            product.cost.formatted(.currency(code: "AUD")),
            "X",
            String(describing: quantity),
            "=",
            cost.formatted(.currency(code: "AUD")),
        ].joined(separator: " ")
    }
}
