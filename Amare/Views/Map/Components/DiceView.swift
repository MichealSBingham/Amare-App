//
//  DiceView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/2/23.
//

import SwiftUI

struct DiceView: View {
    @State var on: Bool = false
    var body: some View {
        
        DiceButtonView(status: on) {
            on.toggle()
        }
       // .preferredColorScheme(.dark)
        
        /*
        Image(systemName: "dice.fill")
            .resizable()
            .preferredColorScheme(.dark)
            .font(.largeTitle)
            .aspectRatio(contentMode: .fit)
            .padding(10)
            .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Material.ultraThinMaterial) //
                    )
            .clipShape(RoundedRectangle(cornerRadius: 10))
                    */
        
    }
    
    @ViewBuilder
    func HeartButton(systemImage: String, status: Bool, activeTint: Color, inActiveTint: Color, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(
                    systemImage: systemImage,
                    font: .body,
                    status: status,
                    activeTint: activeTint,
                    inActiveTint: inActiveTint
                )
                .foregroundColor(status ? activeTint : inActiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : Color("ButtonColor"))
                }
        }
    }
}



struct DiceButtonView: View {
    let systemImage: String = "dice.fill"
    let status: Bool
    let activeTint: Color = .primary
    let inActiveTint: Color = .secondary
    let onTap: () -> ()

    var body: some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(
                    systemImage: systemImage,
                    font: .body,
                    status: status,
                    activeTint: activeTint,
                    inActiveTint: inActiveTint
                )
                .foregroundColor(status ? activeTint : inActiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : Color("ButtonColor"))
                }
        }
        .preferredColorScheme(.dark)
    }
}


#Preview {
    DiceView()
}
