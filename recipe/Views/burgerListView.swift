
//  burgerListView.swift
//  recipe

//  Created by Amgad ElNezamy


import SwiftUI

struct burgerListView: View {
    var body: some View {
        NavigationView{
            List{
                ForEach(burgerData) { item in
                    
                    NavigationLink(destination:DetailedView(burger: item)) {
                        cellView(burger: item)
                            .padding(.vertical ,10)
                    }
                }
            }//List View
            .navigationTitle(" Burger 🍔")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

//PreviewProvider
struct burgerListView_Previews: PreviewProvider {
    static var previews: some View {
        burgerListView()
    }
}
