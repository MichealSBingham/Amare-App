//
//  DirectionStatesEnum.swift
//  Amare
//
//  Created by Micheal Bingham on 10/13/23.
//

import Foundation

// MARK: - Enums
   enum DistanceDirectionState {
       case closeUpInFOV, notCloseUpInFOV, outOfFOV, unknown
   }
   
   /// If 70%  there --> almost there,  if 50% there - halfway there,
   enum DistanceState{
       case farAway, halfwayThere, almostThere
   }
   
