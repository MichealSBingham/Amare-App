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
    
    
    
    // For question 10
    case o38 = "We need to have **similar life goals**."
    case o39 = "We need to **share core values**."
    case o40 = "We need to have our **own individual goals**."
    case o41 = "We need to have a **balance** of shared and individual goals."

    // For question 11
    case o42 = "**Working** towards a common goal with Blake."
    case o43 = "**Sharing** a deep conversation with Blake."
    case o44 = "**Enjoying** a shared hobby or interest with Blake."
    case o45 = "**Supporting** each other through a challenge."

    // For question 12
    case o46 = "I'm **excited** to find a way to make both our dreams work."
    case o47 = "I'm **nervous**, but willing to discuss and compromise."
    case o48 = "I'm **resistant** to changing our plans."
    case o49 = "I'm **unsure** and need time to think."
    
    // For question 13
    case o50 = "**Knowing** Blake was committed to me."
    case o51 = "**Feeling** like Blake trusted me."
    case o52 = "**Seeing** Blake stick with me through a tough time."
    case o53 = "**Hearing** Blake say they loved me."

    // For question 14
    case o54 = "I **trust** our relationship can handle the distance."
    case o55 = "I'm **worried** about our relationship."
    case o56 = "I'm **unsure**, but willing to try."
    case o57 = "I think we should **take a break**."

    // For question 15
    case o58 = "I **feel betrayed** and question Blake's commitment."
    case o59 = "I'm **upset**, but willing to talk it through with Blake."
    case o60 = "I **understand** Blake might have had a good reason."
    case o61 = "I'm **not bothered**, everyone has secrets."

    
    // For question 16
    case o62 = "**Have** a deep conversation with Blake."
    case o63 = "**Plan** a shared experience with Blake."
    case o64 = "**Show** physical affection to Blake."
    case o65 = "**Do** something kind for Blake."

    // For question 17
    case o66 = "**Sharing** our feelings."
    case o67 = "**Doing** something fun together with Blake."
    case o68 = "**Overcoming** a challenge together with Blake."
    case o69 = "**Being** there for Blake in a tough time."

    // For question 18
    case o70 = "**Ask** Blake directly about what's going on."
    case o71 = "**Give** Blake some space."
    case o72 = "**Try** to do something nice to cheer Blake up."
    case o73 = "**Wait** for Blake to come to me."
    
    
    // For question 19
    case o74 = "**Talk** about it with Blake."
    case o75 = "**Have** some space from Blake."
    case o76 = "**Do** something fun with Blake to distract me."
    case o77 = "**Receive** comfort and reassurance from Blake."

    // For question 20
    case o78 = "**Offer** to talk about it with Blake."
    case o79 = "**Give** Blake some space for now."
    case o80 = "**Try** to distract Blake with something fun."
    case o81 = "**Offer** comfort and reassurance to Blake."

    // For question 21
    case o82 = "Blake **listened** to me vent."
    case o83 = "Blake **gave** me some space to unwind."
    case o84 = "Blake **did** something fun to distract me."
    case o85 = "Blake was **comforting** and reassuring."


    // For question 22
    case o86 = "I'm **excited** for the adventure with Blake."
    case o87 = "I'm **nervous** but *willing* to consider it."
    case o88 = "I do **not** want to change."
    case o89 = "I'm **unsure** and need time to think about it."

    // For question 23
    case o90 = "I'm **open** to discussing it *with* Blake."
    case o91 = "I'm **nervous**, but *willing* to consider it."
    case o92 = "I'm **resistant** to the change."
    case o93 = "I'm **unsure**. I need time to think."

    // For question 24
    case o94 = "I **embraced** the change and *adapted*."
    case o95 = "I was **nervous** but worked through it."
    case o96 = "I **resisted** the change."
    case o97 = "I needed *time* to **adjust**."


     

    

    
            

    
    
   
}







