//
//  cellView.swift
//  recipe
//
//  Created by Amgad Salah on 14/05/2023.
//

import SwiftUI

struct cellView: View {
    //properties
    var burger : Burger
    var body: some View {
        HStack{
            Image(burger.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100 ,height: 100,alignment: .center)
                .cornerRadius(15)
            VStack(alignment: .leading,spacing: 7 ){
                Text(burger.title)
                    .font(.title3)
                    .fontWeight(.heavy)
//                    .padding(5)
                Text(burger.method)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }//Vstack
//            .padding()
            Spacer()
                
        }//Hsatack
    }
}

struct cellView_Previews: PreviewProvider {
    static var previews: some View {
        cellView(burger: burgerData[5])
            .previewLayout(.sizeThatFits)
    }
}
