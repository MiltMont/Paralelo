//
//  ContentView.swift
//  Triangle
//
//  Created by Milton Montiel on 29/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
                .border(Color.black, width: 2)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
