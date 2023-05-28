//
//  RGQuizQuestion.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/23.
//

import Foundation

enum RGQuizQuestion: String, CaseIterable, Identifiable{
    
    case question1 = "You and Blake are binge watching a series tonight, but you can't agree on a show. \n \nBlake wants to watch *The Last of Us*—— a **thriller**, but you're in the mood for a **comedy** like *Family Guy*."
    
    
    case question2 = "You and Blake live together and you're both equally responsible for chores.\n\nBut Blake *keeps leaving their dishes in the sink*—— even though you've talked to them about it before, and they've done it **again**."
    
    
    case question3 = "Blake wants to go to a **party** tonight.\n\n You're *not in the mood* for it—— *you want* to **stay in**."
    
    case question4 = "Blake has **pissed you off**.\n\nThey *forgot* something that's important to you, or *did something* to upset you––like forgot your birthday or missed your date."
    
    case question5 = "Blake *seems upset*, but they **aren't talking** about it.\n\nYou've noticed that they've been *quiet all day*."
    
    case question6 = "You're **concerned** about your relationship with Blake.\n\nYou're not seeing each other enough or you just feel something is off in general."
    
    case question7 = "You want Blake to *show you* some **love**."
    
    case question8 = "It's your birthday!\n\nBlake is going to *give* you a **gift**."
    
    //Which *gift* from Blake would *warm your heart* the **most**?
    
    case question9 = "You had a long day.\n\n*Aside from giving you space*, Blake wants to help you **feel** better."
    
    //Aside from some space*, what can Blake **do** to help you feel better?
    
    case question10 = "You and Blake are planning your future *together*. You are thinking about some things in your **plans**."
    
    //\n\nWhat matters **most** to you?
    
    case question11 = "You and Blake want to be *more connected* with each other.\n\nThink of the time you felt **connected** with them or another person."
    
    case question12 = "Blake's dreams do **not** align with your *current* plans." //how do you react?
    
    case question13 = "What makes you more **secure** in your *relationship* with Blake?"
    
    case question14 = "There are some changes to your relationship\n\nBlake needs to move away for a few months."
    
    case question15 = "There are some secrets being exposed.\n\nYou found out Blake has been hiding something."
    
    case question16 = "You are starting to feel *distant* from Blake.\n\nSo, you desire to **reconnect** with them."
    
    case question17 = "You and Blake want to be **closer** with each other.\n\nSo, you try to do what you normally do to feel close with them *or* a past partner."
    
    case question18 = "Blake is being **distant** with you.\n\nYou're starting to *wonder* what's going on."
    
    case question19 = "You're having a **stressful** day."
    
    case question20 = "Blake is *stressed*. You're thinking of ways to **support** them."
    
    case question21 = "Blake is *trying* to help you through a **stressful** time.\n\nThink of a time a partner helped you through stress or imagine Blake helping you."
    
    case question22 = "There are more **changes**.\n\nBlake got a job offer in a new city."
    
    case question23 = "Blake wants to **change** *something* in your relationship.\n\nIt's not something you've considered changing before."
    
    case question24 = "How do you *normally* react to **changes** in your relationships––with Blake or with previous partners?"
    
    
    

    
    
    var id: String {rawValue}
    
    
    
    
}
