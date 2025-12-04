//
//  Session.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/29/25.
//

import Foundation

class Session : NSObject {
    
    static var shared = Session()
    
    private override init() {
        super.init()
    }
    
    private var profile : Profile? = nil
    
    func getProfile() -> Profile? {
        return profile
    }
    
    func setProfile(_ p: Profile?) {
        profile = p
    }
}
