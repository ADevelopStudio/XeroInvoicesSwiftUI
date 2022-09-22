//
//  BoxForCloning.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import Foundation

//Deep coping of class object
extension NSCopying {
    func clone() -> Self {
        guard let new = self.copy() as? Self else {
            fatalError("Somehow not able to make copy. Check your .copy() implementation")
        }
        return new
    }
}

// For Deep cloning testing only
 class TestClass {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension TestClass: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        TestClass(id: self.id, name: self.name)
    }
}

private struct TempForDemoUsage {
    
    ///Example Of Usage
    private func demo() {
        let test1 = TestClass(id: 1, name: "My Name")
        let test2 = test1.clone()
        test1.name = "Changed"
        print(test2.name)
    }
}
