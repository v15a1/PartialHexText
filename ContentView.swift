//
//  ContentView.swift
//  PartialColorText
//
//  Created by Visal Rajapakse on 2023-10-26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    let colors: [Color] = [.blue, .yellow, .green, .purple, .pink, .red, .gray]
    @State private var textColor = Color(hex: "00FFFF")
    
    @State private var data: PartialColorTextData?
    @State private var showJSONData = true
    
    var body: some View {
        VStack {
            // Programmatically driven
            PartialColorText(text: "ENJOY #{FREE UNLIMITED DATA} ON US THIS MONTH!*",
                             textAlignment: .center,
                             textColor)
            .foregroundStyle(.black)
            .font(.system(size: 20, design: .rounded))
            .animation(.easeIn, value: textColor)
            .padding(.bottom)
            
            // Response driven
            if let data {
                PartialColorText(data: data)
                    .font(.title3)
                    .animation(.easeIn, value: textColor)
                    .padding(.bottom)
            } else {
                ProgressView()
            }
            Spacer()
            Button {
                textColor = colors.randomElement()!
            } label: {
                Text("Change")
            }
            
        }
        .padding()
        .onAppear(perform: {
            decode()
        })
        .background(showJSONData ? nil : Color(hex:"#1400B8").ignoresSafeArea())
    }
    
    func decode() {
        if let url = Bundle.main.url(forResource: "Response", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(PartialColorTextData.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.data = jsonData
                }
            } catch {
                print("Mock error:\(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
