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
        let numberOfIndexPages = metadata.count / postsPerPage + 1
        print("Number of index pages: \(numberOfIndexPages)")
        for postIndex in 0..<metadata.count {
            let currentIndexPage = postIndex / postsPerPage
            if postIndex % postsPerPage == 0 {
                print("Generating index page \(currentIndexPage)")
                if currentPagePosts.isEmpty == false {
                    try buildIndexPage(template: template, currentPagePosts: currentPagePosts, currentIndexPage: currentIndexPage, numberOfIndexPages: numberOfIndexPages)
                }
                currentPagePosts.removeAll()
            }
            print("Update index page \(currentIndexPage) with post \(postIndex)")
            currentPagePosts.append(metadata[postIndex])
        }
        print("Generate last page \(currentPagePosts.count)")
        if currentPagePosts.isEmpty == false {
            try buildIndexPage(template: template, currentPagePosts: currentPagePosts, currentIndexPage: numberOfIndexPages, numberOfIndexPages: numberOfIndexPages)
        }
        
    }
    
    private func buildIndexPage(template: Template, currentPagePosts: [FileMetadata], currentIndexPage: Int, numberOfIndexPages: Int) throws {
        let posts: [[String: Any]] = currentPagePosts.map {
            return [
                "title": $0.metadata.title ?? "",
                "date": $0.metadata.date?.stringValue() ?? "",
                "tags": $0.metadata.tags,
                "subtitle": $0.metadata.subtitle ?? "",
                "href": $0.outputFile
            ]
        }
        print("currentIndexPage: \(currentIndexPage), numberOfIndexPages: \(numberOfIndexPages)")
        let newerPage: String
        if currentIndexPage == 2 {
            newerPage = "index.html"
        } else {
            newerPage = "index_\(currentIndexPage-1).html"
        }
        let olderPage: String = "index_\(currentIndexPage+1).html"
        let context: [String: Any] = [
            "posts": posts,
            "hasNewerPage": currentIndexPage > 1,
            "hasOlderPage": currentIndexPage < numberOfIndexPages,
            "newerPage": newerPage,
            "olderPage": olderPage
        ]
        let indexPageHtml = try template.render(context)
        let indexPageHtmlData = indexPageHtml.data(using: .utf8)!
        let outputFile: String
        if currentIndexPage == 1 {
            outputFile = "index.html"
        } else {
            outputFile = "index_\(currentIndexPage).html"
        }
         
        if FileManager.default.fileExists(atPath: outputPath + "/" + outputFile) {
            try FileManager.default.removeItem(atPath: outputPath + "/" + outputFile)
        }
        try indexPageHtmlData.write(to: URL(fileURLWithPath: outputPath + "/" + outputFile))
    }
}
