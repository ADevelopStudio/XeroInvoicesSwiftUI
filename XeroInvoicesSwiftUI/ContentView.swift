//
//  ContentView.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published fileprivate var invoices: [Invoice] = []
    
    func deleteInvoice(at offsets: IndexSet) {
        invoices.remove(atOffsets: offsets)
    }
    
    func addInvoice() {
        let invoiceNumber = (invoices.last?.invoiceNumber ?? 0) + 1
        invoices.append(Invoice(invoiceNumber: invoiceNumber))
    }
    
    var totalMoney: String {
        invoices.map{ $0.getTotal() }.reduce(0, +).inLocalCurrency
    }
}


struct ContentView: View {
    @StateObject fileprivate var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("\(ContentViewStrings.totalMoney.localised): \(viewModel.totalMoney)")
                        .multilineTextAlignment(.leading)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
                
                List {
                    ForEach($viewModel.invoices, id: \.self) { invoice in
                        Section { InvoiceView(invoice: invoice) }
                    }
                    .onDelete {
                        viewModel.deleteInvoice(at: $0)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("\(ContentViewStrings.title.localised): \(viewModel.invoices.count)")
            .toolbar {
                Button {
                    viewModel.addInvoice()
                } label: {
                    Label(ContentViewStrings.addInvoiceButtonTitle.localised, systemImage: "doc.badge.plus")
                        .labelStyle(.titleAndIcon)
                        .font(.callout)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


enum ContentViewStrings: String, CaseIterable {
    case totalMoney = "ContentView_Total_Money" // Total money
    case title = "ContentView_Title" //🧾 Invoices
    case addInvoiceButtonTitle = "ContentView_Add_Invoice" //"Add invoice"
}
