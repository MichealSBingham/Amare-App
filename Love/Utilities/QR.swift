//
//  QR.swift
//  Love
//
//  Created by Micheal Bingham on 7/3/21.
//

import Foundation
import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins

func generateQRCode(from string: String) -> UIImage {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")

    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}


