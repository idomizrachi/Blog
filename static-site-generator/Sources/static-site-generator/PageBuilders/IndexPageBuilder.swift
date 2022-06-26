//
//  IndexPageBuilder.swift
//  
//
//  Created by Ido Mizrachi on 24/06/2022.
//

import Foundation
import PathKit
import Stencil

struct IndexPageBuilder {
    
    let templatesPath: String
    let outputPath: String
    
    func build() throws {
        let environment = Environment(loader: FileSystemLoader(paths: [Path(templatesPath)]))
        let template = try environment.loadTemplate(name: "child.html")
        let context: [String: Any] = [
            "posts": ["post 1", "post 2", "post 3"]
        ]
        let result = try template.render(context)
        print("\(result)")
        
        print("Index template: \(templatesPath)")
        print("Output: \(outputPath)")
    }
}
