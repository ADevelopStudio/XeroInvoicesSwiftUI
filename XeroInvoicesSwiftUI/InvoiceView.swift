//
//  InvoiceView.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import SwiftUI

struct InvoiceView: View {
    @Binding var invoice: Invoice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(InvoiceViewStrings.invoiceNumber.localised)\(invoice.invoiceNumber)")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.leading)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.primary, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.vertical, 4)
            Text(invoice.createdAt)
                .font(.caption2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 2)

            List {
                ForEach(invoice.lineItems, id: \.product.productId) {
                    InvoiceLineView(invoiceLine: $0)
                        .padding(.horizontal, -16)
                        .padding(.vertical, 0)
                }
                .onDelete {
                    invoice.deleteInvoiceLine(at: $0)
                }
            }
            .frame(height: CGFloat(invoice.lineItems.count) * 50)
            .listStyle(.inset)
            HStack {
                Text("\(InvoiceViewStrings.total.localised):")
                    .font(.title3)
                    .bold()
                Spacer()
                Text(invoice.totalCost)
                    .font(.title3)
                    .foregroundColor(.red)
                    .bold()
                    .transition(.push(from: .top))
            }
            HStack {
                Spacer()
                
                Menu {
                    ForEach(Product.allCases, id: \.productId) { product in
                        Button(product.name) {
                            withAnimation {
                                invoice.addInvoiceLine(InvoiceLine(product: product))
                            }
                        }
                    }
                } label: {
                    ButtonView(title: InvoiceViewStrings.addProduct.localised)
                }
            }
        }
    }
    func placeOrder() { }
    
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            InvoiceView(invoice: .constant(.example))
        }
    }
}


enum InvoiceViewStrings: String, CaseIterable {
    case invoiceNumber = "InvoiceView_InvoiceN" //Invoice №
    case total = "InvoiceView_Total" //Total
    case addProduct = "InvoiceView_AddProduct" //"Add a Product"
}
