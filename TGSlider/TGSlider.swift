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
    let segmentWidth: CGFloat
    let segmentHeight: CGFloat
    let smallSegmentScaler: CGFloat
    let totalSegment: Int
    let fontSize: CGFloat
    let progressText: (Float) -> (String)
    
    public init(progress: Binding<Float>,
         segmentWidth:CGFloat = 3,
         segmentHeight: CGFloat = 35,
         smallSegmentScaler: CGFloat = 0.5,
         totalSegment: Int = 10,
         overlayFontSize: CGFloat = 15,
         overlayTextProvider: @escaping (Float) -> (String)) {
        self._percentage = progress
        self.segmentWidth = segmentWidth
        self.segmentHeight = segmentHeight
        self.smallSegmentScaler = smallSegmentScaler
        self.totalSegment = totalSegment
        self.fontSize = overlayFontSize
        self.progressText = overlayTextProvider
    }

    public var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                HStack(alignment: .center) {
                    ForEach(Range<Int>(1...totalSegment)) { _ in
                        Spacer(minLength: 3)
                        Rectangle()
                            .frame(width: segmentWidth, height: min(segmentHeight * smallSegmentScaler, geometry.size.height))
                            .foregroundColor(.gray)
                            .cornerRadius(4)
                        Spacer(minLength: 3)
                    }
                }
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 3)
                    .cornerRadius(7.5)
                
                Text(progressText(percentage))
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
            .padding([.top, .bottom], 10)
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
        TGSlider(progress: $p) { (progress) -> (String) in
            String(Int(ceil(progress))) + "°"
        }
    }
}
