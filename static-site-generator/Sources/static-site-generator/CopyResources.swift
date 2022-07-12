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
        do {
            print("Create folder \(buildPath)")
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: buildPath), withIntermediateDirectories: true)
        } catch {
        }
        let resouceFiles = try FileManager.default.contentsOfDirectory(atPath: templatesResourcesPath)
        try resouceFiles.forEach { resourceFile in
            let buildResourceFile = buildPath + "/" + resourceFile
            if FileManager.default.fileExists(atPath: buildResourceFile) {
                print("Deleting file \(buildResourceFile)")
                try FileManager.default.removeItem(atPath: buildResourceFile)
            }
            print("Copying file \(templatesResourcesPath)/\(resourceFile) to \(buildResourceFile)")
            try FileManager.default.copyItem(atPath: templatesResourcesPath + "/" +  resourceFile, toPath: buildResourceFile)
        }
    }
    
}
