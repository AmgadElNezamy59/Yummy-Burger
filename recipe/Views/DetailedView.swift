//
//  DetailedView.swift
//  recipe
//
//  Created by Amgad ElNezamy on 14/05/2023.
//

import SwiftUI

struct DetailedView: View {
    var burger: Burger
    var body: some View {
        
        ScrollView {
            VStack{
                Image(burger.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
//                    .padding(5)
//                    .frame(height: 350,alignment: .center)
                
                Text(burger.title)
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(4)
                    .foregroundColor(burger.color)
                    .multilineTextAlignment(.center)

                    .padding(.bottom,15)
                
                Text("Ingridient")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.trailing)
                

                
                Text(burger.Ingredients)
                    .padding(20)
                    .font(.title3)
                    .background(Color("back"))
                    .cornerRadius(25)
                    .multilineTextAlignment(.center)
                
                
                
                Text("Method")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top,40)

                
                
                   
                
                Text(burger.method)
                    .padding(20)
                    .font(.title3)
                    .background(Color("back"))
                    .cornerRadius(25)
                    .multilineTextAlignment(.center)
                
                GroupBox(){
                    HStack{
                        Link("For more Yummy burger ", destination: URL(string:"https://www.bbcgoodfoodme.com/")!)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            
                    }
                    
                }.cornerRadius(25)
                
                   
                
                
                
            }//VStack
            .padding(8)
        }
    }
}

struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(burger: burgerData[0])
    }
}
