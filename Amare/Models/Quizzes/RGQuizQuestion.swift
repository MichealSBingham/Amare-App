//
//  RGQuizQuestion.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/23.
//

import Foundation

enum RGQuizQuestion: Hashable, CaseIterable, Identifiable{
	
	
	
	
    case conflictResolution(ConflictResolution)
	case communicationStyle(CommunicationStyle)
	case loveLanguages(LoveLanguages)
	case trustAndCommitment(TrustAndCommitment)
	case emotionalConnection(EmotionalConnection)
	case handlingStress(HandlingStress)
	case attitudeTowardsChange(AttitudeTowardsChange)
	
	
	enum ConflictResolution: String, CaseIterable, Hashable {
		
		case question1 = "You and Blake are binge watching a series tonight, but you can't agree on a show. \n \nBlake wants to watch *The Last of Us*—— a **thriller**, but you're in the mood for a **comedy** like *Family Guy*."
		
		
		case question2 = "You and Blake live together and you're both equally responsible for chores.\n\nBut Blake *keeps leaving their dishes in the sink*—— even though you've talked to them about it before, and they've done it **again**."
		
		
		case question3 = "Blake wants to go to a **party** tonight.\n\n You're *not in the mood* for it—— *you want* to **stay in**."
		
		var id: String { rawValue }
	}
   
    
	enum CommunicationStyle: String, CaseIterable, Hashable {
		case question1 = "Blake has **pissed you off**.\n\nThey *forgot* something that's important to you, or *did something* to upset you––like forgot your birthday or missed your date."
		
		case question2 = "Blake *seems upset*, but they **aren't talking** about it.\n\nYou've noticed that they've been *quiet all day*."
		
		case question3 = "You're **concerned** about your relationship with Blake.\n\nYou're not seeing each other enough or you just feel something is off in general."
		
		var id: String { rawValue }
	}
	
	enum LoveLanguages: String, CaseIterable, Hashable {
		
		case question1 = "You want Blake to *show you* some **love**."
		
		case question2 = "It's your birthday!\n\nBlake is going to *give* you a **gift**."
		
		//Which *gift* from Blake would *warm your heart* the **most**?
		
		case question3 = "You had a long day.\n\n*Aside from giving you space*, Blake wants to help you **feel** better."
		//Aside from some space*, what can Blake **do** to help you feel better?
		
		var id: String { rawValue }
	}
    
	
	
	enum TrustAndCommitment: String, CaseIterable, Hashable{
		
		case question1 = "What makes you *feel* most **secure** in your relationship with Alex?\n\nYou can also reflect on a previous relationship."
		
		case question2 = "There are some changes to your relationship\n\nBlake needs to move away for a few months."
		
		case question3 = "There are some secrets being exposed.\n\nYou found out Blake has been hiding something."
	
		var id: String { rawValue }
		
	}
	

		
		
	enum EmotionalConnection: String, CaseIterable, Hashable{
		
		case question1 = "You are starting to feel *distant* from Blake.\n\nSo, you desire to **reconnect** with them."
	
		case question2 = "You and Blake want to be **closer** with each other.\n\nSo, you try to do what you normally do to feel close with them *or* a past partner."
	
		case question3 = "Blake is being **distant** with you.\n\nYou're starting to *wonder* what's going on."
		
		var id: String { rawValue }
	}
		
	

    
	enum HandlingStress: String, CaseIterable, Hashable{
		
		case question1 = "You're having a **stressful** day."
		
		case question2 = "Blake is *stressed*. You're thinking of ways to **support** them."
		
		case question3 = "Blake is *trying* to help you through a **stressful** time.\n\nThink of a time a partner helped you through stress or imagine Blake helping you."
		
		var id: String { rawValue }
	}
    
    
	
	enum AttitudeTowardsChange: String, CaseIterable, Hashable{
		
		case question1 = "There are more **changes**.\n\nBlake got a job offer in a new city."
		
		case question2 = "Blake wants to **change** *something* in your relationship.\n\nIt's not something you've considered changing before."
		
		case question3 = "How do you *normally* react to **changes** in your relationships––with Blake or with previous partners?"
		
		var id: String { rawValue }
	}
    
    
    
    
	static var allCases: [RGQuizQuestion] {
		   var allCases: [RGQuizQuestion] = []
		   
		   // Append cases from ConflictResolution and other categories
		allCases += ConflictResolution.allCases.map { .conflictResolution($0) }
		allCases += CommunicationStyle.allCases.map { .communicationStyle($0) }
		allCases += LoveLanguages.allCases.map { .loveLanguages($0) }
		allCases += TrustAndCommitment.allCases.map { .trustAndCommitment($0) }
		allCases += EmotionalConnection.allCases.map { .emotionalConnection($0) }
		allCases += HandlingStress.allCases.map { .handlingStress($0) }
		allCases += AttitudeTowardsChange.allCases.map { .attitudeTowardsChange($0) }


		
		   return allCases
	   }
	
	
    
    
 
	var rawValue: String{
		switch self{
		case .conflictResolution(let question):
			return question.rawValue
		case .communicationStyle(let question):
			return question.rawValue
		case .loveLanguages(let question):
			return question.rawValue
		case .trustAndCommitment(let question):
			return question.rawValue
		case .emotionalConnection(let question):
			return question.rawValue
		case .handlingStress(let question):
			return question.rawValue
		case .attitudeTowardsChange(let question):
			return question.rawValue
		}
		
	
	}
    
	var id: String { rawValue }
    
}
