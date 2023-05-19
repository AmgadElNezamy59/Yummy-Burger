//
//  recipeApp.swift
//  recipe
//
//  Created by Amgad ElNezamy on 13/05/2023.
//

import SwiftUI

@main
struct recipeApp: App {
    @AppStorage("isOnBoarding") var isOnBoarding : Bool = true
    var body: some Scene {
        WindowGroup {
            if isOnBoarding{
                onBoardingView()
            }else{
                burgerListView()
            }
            
        }
    }
}
