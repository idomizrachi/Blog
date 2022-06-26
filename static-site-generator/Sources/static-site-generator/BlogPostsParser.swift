//
//  BlogPostsParser.swift
//  
//
//  Created by Ido Mizrachi on 24/06/2022.
//

import Foundation

extension BlogPostsParser {
    struct MissingPostDate: Error {}
}



struct BlogPostsParser {
        
    
    func parse(searchPath: String) throws {
        print("Will search for markdown files in \(searchPath)")
        
        let markdownFiles = try searchMarkdownFiles(searchPath: searchPath)
        print("Found:\n\(markdownFiles)")
    }
    
    private func searchMarkdownFiles(searchPath: String) throws -> [String] {
        let markdownFiles = try FileManager.default.contentsOfDirectory(atPath: searchPath)
        return markdownFiles.map({ searchPath.appending("/" + $0) })
    }
    
}
