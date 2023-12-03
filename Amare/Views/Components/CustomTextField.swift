import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var isReturnKeyDisabled: Bool = true 

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator

        // Apply SwiftUI-like styles
        textField.placeholder = placeholder
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.textColor = UIColor.label
        textField.borderStyle = .roundedRect
        textField.enablesReturnKeyAutomatically = isReturnKeyDisabled

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ textField: CustomTextField) {
            self.parent = textField
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            !parent.isReturnKeyDisabled
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
