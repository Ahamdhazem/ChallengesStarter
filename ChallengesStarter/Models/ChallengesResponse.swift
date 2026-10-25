//
//  Chalanges.swift
//  ChallengesStarter
//
//  Created by LP Mackbook on 25/10/2026.
//

import Foundation
// Get Changes Response

struct ChallengesResponse:Decodable{
    let statusCode : String!
    let message : String!
    let data : Data!
    let error : Error!
    
    
    struct Data : Decodable{
        
        let challenges : [MayChallenge]!

        
        struct MayChallenge: Decodable{
            let id : Int!
            let name : String!
            let code : String!
            let challenge_type : String!
            let state : String!
            let state_color : String!
            let date_start : String!
            let date_end : String!
            let progress_pct : Int!
            let progress_value : Int!
            let target_value : Int!
            let remaining_value : Int!
            let progress_title : String!
            let activity : String!
            let days_to_expiry : Int!
            let expiry_message : String!
            let rewards : [Reward]!
            
            struct Reward : Decodable{
                let id : Int!
                let name : String!
                let icon :String!
                let reward_type:String!
                let state : String!
                let can_claim : Bool!
                let entitlement_id : Int!
                let presentation: String!
            }
        }

    }
    struct Error : Decodable{
        let code : String!
        let title : String!
        let message : String!
        let detail :String!
        let extra_data : [String:String]!
        
    }
}

//{
//  "statusCode": "success",
//  "message": "",
//  "data": {
//    "challenges": [
//      {
//        "id": 3,
//        "name": "Summer Activation Race",
//        "code": "TRAINING_PERIOD_TARGET",
//        "challenge_type": "period_target",
//        "state": "in_progress",
//        "state_color": "#FFAA00",
//        "date_start": "2026-08-01",
//        "date_end": "2026-08-10",
//        "progress_pct": 75,
//        "progress_value": 150,
//        "target_value": 200,
//        "remaining_value": 50,
//        "progress_title": "200 activations by Aug 10 to unlock reward 🔥",
//        "activity": "200 Prepaid Activation",
//        "days_to_expiry": 1,
//        "expiry_message": "1 day to expiry this challenge.",
//        "rewards": [
//          {
//            "id": 101,
//            "name": "Spin the Wheel",
//            "icon": "",
//            "reward_type": "spin_entitlement",
//            "state": "granted",
//            "can_claim": false,
//            "entitlement_id": 101,
//            "presentation": "wheel"
//          },
//          {
//            "id": 102,
//            "name": "300 Pts",
//            "icon": "",
//            "reward_type": "points",
//            "state": "granted",
//            "can_claim": false
//          },
//
//        ]
//      },
//      {
//        "id": 4,
//        "name": "Summer Activation Race",
//        "code": "TRAINING_PERIOD_TARGET",
//        "challenge_type": "period_target",
//        "state": "succeeded",
//        "state_color": "#16B364",
//        "date_start": "2026-08-01",
//        "date_end": "2026-08-10",
//        "progress_pct": 100,
//        "progress_value": 200,
//        "target_value": 200,
//        "remaining_value": 0,
//        "progress_title": "Goal Completed - reward unlocked 🎉",
//        "activity": "200 Prepaid Activation",
//        "days_to_expiry": null,
//        "expiry_message": "",
//        "rewards": [
//          {
//            "id": 101,
//            "name": "Spin the Wheel",
//            "icon": "",
//            "reward_type": "spin_entitlement",
//            "state": "granted",
//            "can_claim": true,
//            "entitlement_id": 101,
//            "presentation": "wheel"
//          },
//        
//        ]
//      }
//    ]
//  },
//  "error": {
//    "code": "",
//    "title": "",
//    "message": "",
//    "detail": "",
//    "extra_data": {}
//  }
//}
