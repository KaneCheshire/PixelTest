//
//  Bundle+PrincipleClassModule.swift
//  AEXML
//
//  Created by Kane Cheshire on 19/09/2018.
//

import Foundation

extension Bundle {
    
    var moduleForPrincipleClass: Module? {
        guard let principalClass = principalClass, let moduleName = String(reflecting: type(of: principalClass)).components(separatedBy: ".").first else { return nil }
        return Module(name: moduleName)
    }
    
}
