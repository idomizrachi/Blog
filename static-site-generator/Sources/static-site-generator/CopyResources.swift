//
//  CopyResources.swift
//  
//
//  Created by Ido Mizrachi on 28/06/2022.
//

import Foundation

struct CopyResources {
    let templatesResourcesPath: String
    let buildPath: String
    
    func run() throws {
        let resouceFiles = try FileManager.default.contentsOfDirectory(atPath: templatesResourcesPath)
        try resouceFiles.forEach { resourceFile in
            let buildResourceFile = buildPath + "/" + resourceFile
            try FileManager.default.copyItem(atPath: templatesResourcesPath + "/" +  resourceFile, toPath: buildResourceFile)
        }
    }
    
}
