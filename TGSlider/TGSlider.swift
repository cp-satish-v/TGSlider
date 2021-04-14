//
//  ContentView.swift
//  TGSlider
//
//  Created by Divyesh Vekariya on 13/02/21.
//

import SwiftUI
import UIKit

public struct TGSlider: View {
    
    @Binding var percentage: Float // or some value binded
    @State var segmentWidth: CGFloat = 3
    @State var segmentHeight: CGFloat = 35
    @State var smallSegmentHeight: CGFloat = 0.5
    @State var totalSegment: Int = 10
    @State var progressType: String = "°"
    @State var fontSize: CGFloat = 15

    public var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                HStack(alignment: .center) {
                    ForEach(Range<Int>(0...totalSegment - 1)) { _ in
                        Spacer(minLength: 3)
                        Rectangle()
                            .frame(width: segmentWidth, height: min(segmentHeight * smallSegmentHeight, geometry.size.height))
                            .foregroundColor(.gray)
                            .cornerRadius(4)
                        Spacer(minLength: 3)
                    }
                }
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 3)
                    .cornerRadius(7.5)
                
                Text("\(Int(ceil(self.percentage)))\(progressType)")
                    .font(.system(size: fontSize))
                    .frame(alignment: .center)
                    .padding(.bottom, 60)
                    .padding(.leading, -6)
                    .offset(CGSize(width: max(min(((geometry.size.width - segmentWidth) * CGFloat(self.percentage / 100)), geometry.size.width - 26), 6), height: 0))
                
                Rectangle()
                    .frame(width:segmentWidth, height: min(segmentHeight, geometry.size.height))
                    .foregroundColor(.accentColor)
                    .cornerRadius(4)
                    .offset(CGSize(width: (geometry.size.width - segmentWidth) * CGFloat(self.percentage / 100), height: 0))
            }
            .padding([.top, .bottom], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    // TODO: - maybe use other logic here
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                }))
        }.frame(height: 80)
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var p: Float = 50
    
    static var previews: some View {
        TGSlider(percentage: $p)
    }
}
