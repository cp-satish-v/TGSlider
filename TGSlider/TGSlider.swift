//
//  ContentView.swift
//  TGSlider
//
//  Created by Divyesh Vekariya on 13/02/21.
//

import SwiftUI
import UIKit

public struct Theme {
    public let thumbColor: Color
    public let ladderColor: Color
    public let textColor: Color
    
    public static func `default`() -> Theme {
        .init(thumbColor: .accentColor, ladderColor: .gray, textColor: .black)
    }
}

public class SliderDataModel: ObservableObject {
    @Published public var value: Float
    
    public init(value: Float) {
        self.value = value
    }
}

public struct TGSlider: View {
    
    @ObservedObject var data: SliderDataModel // or some value binded
    let segmentWidth: CGFloat
    let segmentHeight: CGFloat
    let smallSegmentScaler: CGFloat
    let totalSegment: Int
    let fontSize: CGFloat
    let minValue: Float
    let maxValue: Float
    let progressText: (Float) -> (String)
    let theme: Theme
    
    public init(data: SliderDataModel,
         segmentWidth: CGFloat = 3,
         segmentHeight: CGFloat = 35,
         smallSegmentScaler: CGFloat = 0.5,
         totalSegment: Int = 10,
         overlayFontSize: CGFloat = 15,
         minValue: Float = 0,
         maxValue: Float = 100,
         theme: Theme = .default(),
         overlayTextProvider: @escaping (Float) -> (String)) {
        self.data = data
        self.segmentWidth = segmentWidth
        self.segmentHeight = segmentHeight
        self.smallSegmentScaler = smallSegmentScaler
        self.totalSegment = totalSegment
        self.fontSize = overlayFontSize
        self.minValue = minValue
        self.maxValue = maxValue
        self.theme = theme
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
                            .foregroundColor(theme.ladderColor)
                            .cornerRadius(4)
                        Spacer(minLength: 3)
                    }
                }
                Rectangle()
                    .foregroundColor(theme.ladderColor)
                    .frame(height: 3)
                    .cornerRadius(7.5)
                
                let _percentage = data.value.ilerp(min: minValue, max: maxValue) * 100
                
                Text(progressText(data.value))
                    .font(.system(size: fontSize))
                    .foregroundColor(theme.textColor)
                    .position(x: (geometry.size.width - segmentWidth) * CGFloat(_percentage / 100), y: 0)
                
                Rectangle()
                    .frame(width:segmentWidth, height: min(segmentHeight, geometry.size.height))
                    .foregroundColor(theme.thumbColor)
                    .cornerRadius(4)
                    .offset(CGSize(width: (geometry.size.width - segmentWidth) * CGFloat(_percentage / 100), height: 0))
            }
            .padding([.top, .bottom], 10)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            // TODO: - maybe use other logic here
                            let result = min(max(0, Float(value.location.x / geometry.size.width)), 1)
                            self.data.value  = Float(result).lerp(min: minValue, max: maxValue)
                        }))
        }
        .frame(height: 80)
    }
}

extension Float {
  /// Linear interpolation
  public func lerp(min: Float, max: Float) -> Float {
    return min + (self * (max - min))
  }
    
  /// Inverse linear interpolation
  public func ilerp(min: Float, max: Float) -> Float {
    return (self - min) / (max - min)
  }
}

struct ContentView_Previews: PreviewProvider {
    @State static var p: Float = 50
    
    static var previews: some View {
        TGSlider(data: .init(value: p)) { (progress) -> (String) in
            String(Int(progress)) + "°"
        }
    }
}
