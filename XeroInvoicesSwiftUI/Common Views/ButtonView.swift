//
//  ButtonView.swift
//  XeroInvoicesSwiftUI
//
//  Created by Dmitrii Zverev on 21/9/2022.
//

import SwiftUI

struct ButtonView: View {
    var title: String
    var body: some View {
        Text(title)
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .cornerRadius(8)
            .shadow(radius: 6, x: 2, y: 2)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "Press me")
    }
}
