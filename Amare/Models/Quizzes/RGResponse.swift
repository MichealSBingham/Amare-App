//
//  RGResponse.swift
//  Amare
//
//  Created by Micheal Bingham on 5/28/23.
//

import Foundation


/// Enum to represent a response choice for the `RelationshipQuizQuestion`
enum RGResponse: String, Identifiable  {
  
    var id: String { rawValue }
    

    // For question 1
    case o1 = "**Find out** *why* Blake likes thrillers so much."
    case o2 = "**Defend** your choice of watching a comedy passionately."
    case o3 = "*Suggest* watching **separately**."
    case o4 = "*Propose* watching **something else** entirely new."
        
    
    // For question 2
    case o5 = "**Talk** to Blake about it *again*."
    case o6 = "Leave *your dishes* in the sink **too**."
    case o7 = "Clean up for Blake **without** saying anything."
    case o8 = "Come up with another *playful* creative way to **encourage** them to do their dishes."
            
            
        
  // For question 3
    case o9 = "Tell them *how you feel* and make a **compromise**."
    case o10 = "**Insist** on staying in."
    case o11 = "Suck it up and **agree** to go."
    case o12 = "*Suggest* you both do your own thing for the night."
            

    
    
   
}







