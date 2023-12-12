//
//  ChatWithDasha.swift
//  Amare
//
//  Created by Micheal Bingham on 12/11/23.
//

import SwiftUI
import StreamChat


struct ChatWithDasha: View {
    
    @State private var typedText = ""
    var message: String? = "🌌 Click to explore and chat with me about your unique bond! 👫✨ Discover your cosmic connection and learn more about your dynamics in detail!"

    var body: some View {
        
        VStack{
            
            
            HStack{
                
                CircularProfileImageView(profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/findamare.appspot.com/o/0_1.png?alt=media&token=c4e66adc-9ba3-4acf-b6bd-f7e2ee167237")
                    .frame(width: 50, height: 50)
                    .offset(y: 70)
                
                Text(typedText)
                    .padding()
                    .background(Color(.amare))
                  .clipShape(BubbleShape(myMessage: false))
                   .foregroundColor(.white)
                   .onAppear {
                       //typeWriterEffect(for: message ?? "")
                           }
            }.onChange(of: message) { old, new in
                typeWriterEffect(for: new ?? "")
            }
            
        }
       
    }
    
        private func typeWriterEffect(for text: String) {
            for (index, character) in text.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    typedText += String(character)
                }
            }
        }

}

//struct MessageBubbleView: View {
//    @State private var typedText = ""
//    private let message = "Your message goes here..."
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text(typedText)
//                    .font(.body)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
//                Spacer()
//            }
//            
//            Spacer()
//            
//            
//            
//            Text("Here’s to the crazy ones, the misfits, the rebels, the troublemakers, the round pegs in the square holes… the ones who see things differently — they’re not fond of rules…")
//                .padding()
//                .background(Color(UIColor.systemBlue)
//                    .clipShape(BubbleShape(myMessage: true))
//                    .foregroundColor(.white)
//            
//            
//        }
//        .padding()
//        .onAppear {
//            typeWriterEffect(for: message)
//        }
//    }
//    
//
//    
//    private func typeWriterEffect(for text: String) {
//        for (index, character) in text.enumerated() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
//                typedText += String(character)
//            }
//        }
//    }
//}
//
//
//                            
//
#Preview {
    ChatWithDasha()
        .preferredColorScheme(.dark)
}
