//
//  ContentView.swift
//  recipe
//
//  Created by Amgad ElNezamy


import SwiftUI

struct onBoardingView: View {
    var body: some View {
        VStack {
            TabView {
                ForEach(burgerData) { item in
                    cardView(burger: item)
                }.cornerRadius(40)
            }.tabViewStyle(PageTabViewStyle())
             .padding(.horizontal,15)
        }//Vstack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingView()
    }
}
