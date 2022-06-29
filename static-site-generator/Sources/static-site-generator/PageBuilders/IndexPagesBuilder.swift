//
//  IndexPageBuilder.swift
//  
//
//  Created by Ido Mizrachi on 24/06/2022.
//

import Foundation
import PathKit
import Stencil

/// This will generate the main index.html and also the needed
struct IndexPagesBuilder {
    
    ///Expected to be sorted
    let metadata: [FileMetadata]
    let templatesPath: String
    let outputPath: String
    let postsPerPage: Int
    
    func run() throws {
        let environment = Environment(loader: FileSystemLoader(paths: [Path(templatesPath)]))
        let template = try environment.loadTemplate(name: templatesPath + "/index-stencil.html")
        
        var currentPagePosts: [FileMetadata] = []
        for postIndex in 0..<metadata.count {
            if postIndex % postsPerPage == 0 {
                print("Generating index page \(postIndex / postsPerPage)")
                if currentPagePosts.isEmpty == false {
                    try buildIndexPage(template: template, currentPagePosts: currentPagePosts, postIndex: postIndex)
                }
                currentPagePosts.removeAll()
            }
            print("Update index page \(postIndex / postsPerPage) with post \(postIndex)")
            currentPagePosts.append(metadata[postIndex])
        }
        print("Generate last page")
    }
    
    private func buildIndexPage(template: Template, currentPagePosts: [FileMetadata], postIndex: Int) throws {
        let posts: [[String: Any]] = currentPagePosts.map {
            return [
                "title": $0.metadata.title ?? "",
                "date": $0.metadata.date ?? "",
                "tags": $0.metadata.tags,
                "subtitle": $0.metadata.subtitle ?? "",
                "href": $0.outputFile
            ]
        }
        let context: [String: Any] = ["posts": posts]
        let indexPageHtml = try template.render(context)
        let indexPageHtmlData = indexPageHtml.data(using: .utf8)!
        let outputFile = (postIndex / postsPerPage) - 1 == 0 ? "index.html" : "index_\(postIndex / postsPerPage).html"
        if FileManager.default.fileExists(atPath: outputPath + "/" + outputFile) {
            try FileManager.default.removeItem(atPath: outputPath + "/" + outputFile)
        }
        try indexPageHtmlData.write(to: URL(fileURLWithPath: outputPath + "/" + outputFile))
    }
}
