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
    
    
    // For question 4
    case o13 = "**Talk** to Blake about *your feelings*."
    case o14 = "**Show** your feelings through your *actions*."
    case o15 = "*Keep* your feelings to **yourself**."
    case o16 = "Do something **nice** for Blake to feel better."

    // For question 5
    case o17 = "**Ask** Blake directly about what's bothering them."
    case o18 = "*Give* Blake some **space** to process their feelings."
    case o19 = "Do something **nice** to cheer Blake up."
    case o20 = "*Act* as if everything is **normal**."

    // For question 6
    case o21 = "**Directly** express your concern and feelings to Blake."
    case o22 = "*Drop* subtle hints about your concern."
    case o23 = "*Text* Blake a paragraph to express your feelings."
    case o24 = "*Wait* for a right moment to bring it up."

    
    // For question 7
    
    case o25 = "Blake **saying** something really affirming to me."
    case o26 = "Blake **doing** something helpful for me."
    case o27 = "Blake **giving** me a thoughtful gift."
    case o28 = "Blake **spending** quality time with me."
    case o29 = "Blake **giving** me a hug or a touch."
    
    
    // For question 8
    case o30 = "A heartfelt **letter** from Blake."
    case o31 = "A surprise **party** with all my friends organized by Blake."
    case o32 = "A day of **pampering** and relaxation planned by Blake."
    case o33 = "A thoughtful **gift** from Blake that shows they really know me."
    
    
    // For question 9
    case o34 = "A comforting **hug** from Blake."
    case o35 = "A **listening ear** from Blake."
    case o36 = "**Help** from Blake with chores."
    case o37 = "A surprise **treat** or gift from Blake."
    
    
    
    
    
    
    // For question 7
    /*
    case o25 = "Knowing Blake was **committed** to me."
    case o26 = "*Feeling* like Blake **trusted** me."
    case o27 = "Seeing Blake stick with me through a **tough time**."
    case o28 = "Hearing Blake say they **loved** me."

    // For question 8
    case o29 = "**Trust** our relationship can handle the distance."
    case o30 = "I'm **worried** about our relationship."
    case o31 = "I'm **unsure**, but willing to try."
    case o32 = "I think we should **take a break**."

    // For question 9
    case o33 = "I **feel betrayed** and question Blake's commitment."
    case o34 = "I'm **upset**, but willing to talk it through with Blake."
    case o35 = "I **understand** Blake might have had a good reason."
    case o36 = "I'm **not bothered**, everyone has secrets."
*/
    
    

    
            

    
    
   
}







