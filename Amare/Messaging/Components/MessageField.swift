//
//  MessageField.swift
//  Amare
//
//  Created by Micheal Bingham on 6/3/22.
//

import SwiftUI

struct MessageField: View {
	@State private var message = ""
	
    var body: some View {
        
		HStack{
			CustomMessageField(text: $message)
			
			Button {
				//
				print("Message sent")
				message = ""
			} label: {
				Image(systemName: "paperplane.fill")
					.padding(10)
					.foregroundColor(.red)
					//background(Color(.gray))
					.foregroundStyle(.ultraThinMaterial)
					.cornerRadius(50)
					
			}

			
	
				
		}
		.padding(.horizontal)
		.padding(.vertical, 10)
		//.background(Color(UIColor.darkGray))
		.cornerRadius(50)
		.overlay(
					RoundedRectangle(cornerRadius: 50)
						.stroke(Color.gray, lineWidth: 0.5)
				)
		.padding()
		
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField()
			.preferredColorScheme(.dark)
	}
}


struct CustomMessageField: View {
	
	var placeholder: Text = Text("Say something...")
	@Binding var text: String
	var editingChanged: (Bool) -> () = { _ in }
	var commit: () -> () = {}
	
	var body: some View {
		ZStack(alignment: .leading) {
			
			if text.isEmpty {
				placeholder
					.opacity(0.5)
			}
			
			TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
		}
	}
	
}
