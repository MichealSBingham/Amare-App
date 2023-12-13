//
//  RadialChart.swift
//  Amare
//
//  Created by Micheal Bingham on 10/21/23.
//

import SwiftUI



struct RadialChart: View {
    var progress: Double?
    
    @State private var displayedNumber: Int = 0
    @State private var displayedProgress: CGFloat = 0

     var gcolor1: Color = Color(red: 240 / 255, green: 41 / 255, blue: 196 / 255)
     var gcolor2: Color = Color(red: 255 / 255, green: 2 / 255, blue: 201 / 255)

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .foregroundColor(.gray)
                .opacity(0.1)

            Circle()
                .trim(from: 0.0, to: displayedProgress)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .fill(AngularGradient(gradient: Gradient(colors: [gcolor2, gcolor1]), center: .center))
                .rotationEffect(.degrees(-90))

            Text("\(progress != nil ? String(Int(displayedNumber)) : "?")")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .fontWeight(.black)
                .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                    animateNumberChange(target: Int((progress ?? 0) * 100))
                }
        }
        .onAppear {
            //AmareApp().delay(1) {
                
                withAnimation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 2.5)) {
                    displayedProgress = CGFloat(progress ?? 0)
                }
           // }
            
        }
        .onChange(of: progress) { newValue in
            withAnimation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 2.5)) {
                displayedProgress = CGFloat(newValue ?? 0)
            }
        }
        .frame(width: 200, height: 100)
    }

    func animateNumberChange(target: Int) {
        if displayedNumber < target {
            displayedNumber += 1
        } else if displayedNumber > target {
            displayedNumber -= 1
        }
    }
}

struct RadialChartAdjustableSize: View {
    var progress: Double?
    var size: CGFloat  // Overall size of the chart

    @State private var displayedNumber: Int = 0
    @State private var displayedProgress: CGFloat = 0

    var gcolor1: Color = Color(red: 240 / 255, green: 41 / 255, blue: 196 / 255)
    var gcolor2: Color = Color(red: 255 / 255, green: 2 / 255, blue: 201 / 255)

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: size / 10) // Adjust stroke width based on size
                .foregroundColor(.gray)
                .opacity(0.1)

            Circle()
                .trim(from: 0.0, to: displayedProgress)
                .stroke(style: StrokeStyle(lineWidth: size / 10, lineCap: .round))
                .fill(AngularGradient(gradient: Gradient(colors: [gcolor2, gcolor1]), center: .center))
                .rotationEffect(.degrees(-90))

            Text("\(progress != nil ? String(Int(displayedNumber)) : "?")")
                .font(.system(size: size / 4)) // Adjust font size based on size
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .fontWeight(.black)
                .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                    animateNumberChange(target: Int((progress ?? 0) * 100))
                }
        }
        .onAppear {
            //AmareApp().delay(1) {
                
                withAnimation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 2.5)) {
                    displayedProgress = CGFloat(progress ?? 0)
                }
           // }
            
        }
        .onChange(of: progress) { newValue in
            withAnimation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 2.5)) {
                displayedProgress = CGFloat(newValue ?? 0)
            }
        }
        .frame(width: size, height: size) // Set frame size
    }

    func animateNumberChange(target: Int) {
        if displayedNumber < target {
            displayedNumber += 1
        } else if displayedNumber > target {
            displayedNumber -= 1
        }
    }
}


struct RadialChart_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedRadialChartPreview()
    }
}

struct AnimatedRadialChartPreview: View {
    @State private var progress: CGFloat = 0.0
    @State private var progressSet: Double?

    var body: some View {
        VStack {
            RadialChartAdjustableSize(progress: progressSet, size: 200)
            Slider(value: $progress, in: 0...1)
        }
        .onTapGesture {
            //withAnimation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 2.5)){
                self.progressSet = progress
            //}
                
            
        }
    }
}
