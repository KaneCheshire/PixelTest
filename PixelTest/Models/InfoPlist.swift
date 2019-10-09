//
//  InfoPlist.swift
//  PixelTest
//
//  Created by Kane Cheshire on 09/10/2019.
//

import Foundation

struct InfoPlist {
    
    let recordAll: Bool
    
    init(bundle: Bundle) {
        recordAll = bundle.infoDictionary?[.recordAll] as? Bool ?? false
    }
    
}

private extension String {
    
    static let recordAll = "PTRecordAll"
    
}
