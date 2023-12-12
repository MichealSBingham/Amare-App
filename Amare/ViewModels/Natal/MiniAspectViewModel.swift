//
//  MiniAspectViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 12/11/23.
//

import Foundation
class MiniAspectViewModel: ObservableObject {
    
    @Published var isLoadingUnlock: Bool = false
    @Published var notEnough: Bool = false
    
    func unlock(aspect: AspectReadData){
        isLoadingUnlock = true
        notEnough = false
        
        APIService.shared.getAspectRead(data: aspect) { [self] result in
            switch result {
            case .success(let success):
                print("success getAspectRead: \(success)")
                self.isLoadingUnlock = false
            case .failure(let failure):
                print("Failed the request: \(failure)")
                self.isLoadingUnlock = false
                self.notEnough = true
            }
        }
    }
    
}
