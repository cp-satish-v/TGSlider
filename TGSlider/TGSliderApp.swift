//
//  TGSliderApp.swift
//  TGSlider
//
//  Created by Divyesh Vekariya on 13/02/21.
//

import SwiftUI

@main
struct TGSliderApp: App {
    
    @State var p: Float = 50
    
    var body: some Scene {
        WindowGroup {
            TGSlider(data: .init(value: p)) { progress in
                String(Int(progress)) + "°"
            }
        }
    }
}
