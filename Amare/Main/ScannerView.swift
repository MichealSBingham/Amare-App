//
//  ScannerView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import CodeScanner
import AVFoundation


struct ScannerView: View {
    @EnvironmentObject private var account: Account
    
    @State var haveCameraAccess: Bool = false
    
    var body: some View {
        
        ZStack{
            
            Group{
                Background(style: .creative)
                textForDeniedCameraAccess()
                
            }.opacity(!haveCameraAccess ? 1: 0)
            
            Camera()
        }
        
    
            
    }
    
    
    func Camera() -> some View   {
        
        return     CodeScannerView(codeTypes: [.qr], scanMode: .oncePerCode) { result in
            
            if case let .success(code) = result {
                
                print("The code is ... \(code)")
            }
        }.onAppear {
            checkIfWeHaveAccessToCamera()
        }
        .opacity(haveCameraAccess ? 1: 0 )

    }
    
    
    func textForDeniedCameraAccess() -> some View  {
        
        return Text("Please give us access to your camera")
           .foregroundColor(.white)
           //.font((Font.custom("MontserratAlternates-SemiBold", size: 17)))
           .onTapGesture {
               
               AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                   if granted {
                       //access allowed
                       print("Gave access to camera")
                       haveCameraAccess = true
                   } else {
                       //access denied
                       print("No access to camera")
                       haveCameraAccess = false
                   }
               })

           }
           
    
        
    }
    
    
    func checkIfWeHaveAccessToCamera()  {
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            print("We can access the camera")
            haveCameraAccess = true
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    print("Gave access to camera")
                    haveCameraAccess = true
                } else {
                    //access denied
                    print("No access to camera")
                    haveCameraAccess = false
                }
            })
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
            .environmentObject(Account())
            .preferredColorScheme(.dark)
            
    }
}
