//
//  Product.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import Foundation

enum Product: CaseIterable, Codable, Equatable {
    case banana
    case blueberries
    case orange
    case pizza
}


extension Product {
    var cost: Double {
        switch self {
        case .banana:
            return 10.33
        case .blueberries:
            return  6.27
        case .orange:
            return 5.22
        case .pizza:
            return 9.99
        }
    }
    
    var name: String {
        let name = String(describing: self)
        return [name.first?.uppercased(), name.dropFirst().lowercased()].compactMap({$0}).joined()
    }
    
    var productId: Int {
        Product.allCases.firstIndex(of: self) ?? 0
    }
}
