//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Nihat on 4.03.2022.
//

import Foundation

class UserSingleton {
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
