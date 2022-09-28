//
//  String+Ext.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 28/9/2022.
//

import Foundation

extension String {
    var localised: String {
        NSLocalizedString(self, comment: self)
    }
}

extension Double {
    var inLocalCurrency: String {
        return self.formatted(.currency(code: Locale.current.currency?.identifier ?? "AUD"))
    }
}

extension RawRepresentable where RawValue == String {
    var localised: String { self.rawValue.localised }
}

