//
//  cardView.swift
//  recipe
//
//  Created by Amgad ElNezamy on 13/05/2023.
//

import SwiftUI

struct cardView: View {
    //properties
    @AppStorage("isOnBoarding") var isOnBoarding : Bool = true
   

    var burger : Burger
    @State var isAnimating :Bool = false
    
    //body
    var body: some View {
        VStack{
            Image(burger.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(30.0)
                .padding(20)
                .padding(.bottom,30)
                .scaleEffect(isAnimating ? 1 :0.6)
                .animation(.linear(duration: 0.5),value: isAnimating)
            
            
            
            Text(burger.title)
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            Text(burger.method)
                .font(.title3)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(20)
            
            
            
            Button {
                isOnBoarding = false
            } label: {
                Image(systemName: "arrow.right.circle")
                Text("Start")
                
            }
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.heavy)
            .padding(.horizontal,25)
            .padding(.vertical,15)
            
            .background(burger.color)
            .cornerRadius(20)
            
        }//Vstack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color("back"))
        
        .onAppear {
            isAnimating = true
        }
        
        
        
    }
}

struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView(burger: burgerData[0])
    }
}
