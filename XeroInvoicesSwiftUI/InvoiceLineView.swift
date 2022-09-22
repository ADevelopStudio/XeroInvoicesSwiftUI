//
//  InvoiceLineView.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import SwiftUI

struct InvoiceLineView: View {
    @State var invoiceLine: InvoiceLine
    
    var body: some View {
        HStack {
            Text(invoiceLine.product.name)
                .font(.callout)
                .bold()
            Spacer()
            Text(String(invoiceLine.costBreakDown))
                .font(.subheadline)
        }
        .frame(height: 35)
    }
}

struct InvoiceLineView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            InvoiceLineView(invoiceLine: InvoiceLine(product: .pizza, quantity: 3))
        }
    }
}
