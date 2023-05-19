//
//  burger.swift
//  recipe
//
//  Created by Amgad ElNezamy on 13/05/2023.
//

import SwiftUI
struct Burger: Identifiable{
    let id = UUID()
    let title : String
    let image : String
    let Ingredients : String
    let method : String
    let color : Color
}
