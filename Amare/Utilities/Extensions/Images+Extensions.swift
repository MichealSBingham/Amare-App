//
//  Images+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 11/15/23.
//

import Foundation
import SwiftUI

extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool = false , contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
          var width: CGFloat
          var height: CGFloat
          var newImage: UIImage

          let size = self.size
          let aspectRatio =  size.width/size.height

          switch contentMode {
              case .scaleAspectFit:
                  if aspectRatio > 1 {                            // Landscape image
                      width = dimension
                      height = dimension / aspectRatio
                  } else {                                        // Portrait image
                      height = dimension
                      width = dimension * aspectRatio
                  }

          default:
              fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
          }

          if #available(iOS 10.0, *) {
              let renderFormat = UIGraphicsImageRendererFormat.default()
              renderFormat.opaque = opaque
              let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
              newImage = renderer.image {
                  (context) in
                  self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
              }
          } else {
              UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                  self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                  newImage = UIGraphicsGetImageFromCurrentImageContext()!
              UIGraphicsEndImageContext()
          }
        
        

          return newImage
      }
  }

// Extend UIImage for iOS
#if canImport(UIKit)
extension UIImage {
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 1) // Adjust compressionQuality as needed
    }
}
#endif

// Extend NSImage for macOS
#if canImport(AppKit)
extension NSImage {
    func toData() -> Data? {
        guard let tiffRepresentation = self.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .jpeg, properties: [:])
    }
}
#endif
