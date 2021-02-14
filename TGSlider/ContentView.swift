//
//  ContentView.swift
//  TGSlider
//
//  Created by Divyesh Vekariya on 13/02/21.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var percentage: Float // or some value binded
    @State var segmentWidth:CGFloat = 3
    @State var segmentHeight:CGFloat = 16

    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                HStack(alignment: .center) {
                    ForEach(Range<Int>(0...8)) { _ in
                        Spacer(minLength: 3)
                        Rectangle()
                            .frame(width:segmentWidth, height: min(segmentHeight * 0.6, geometry.size.height))
                            .foregroundColor(.gray)
                        Spacer(minLength: 3)
                    }
                    
                }
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 3)
                Rectangle()
                    .frame(width:segmentWidth, height: min(segmentHeight, geometry.size.height))
                    .foregroundColor(.accentColor)
                    .offset(CGSize(width: (geometry.size.width - segmentWidth) * CGFloat(self.percentage / 100), height: 0))
            }
            .padding([.top, .bottom], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    // TODO: - maybe use other logic here
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                }))
        }.frame(height: 36)
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var p: Float = 50
    
    static var previews: some View {
        ContentView(percentage: $p)
    }
}
