//
//  BlogPostsParser.swift
//  
//
//  Created by Ido Mizrachi on 24/06/2022.
//

import Foundation
import Markdown
import PathKit
import Stencil

extension BlogPostsBuilder {
    struct MissingPostDate: Error {}
}

struct FileMetadata {
    let file: String
    let outputFile: String
    let metadata: Metadata
}

struct ParsingResult {
    let filesMetadata: [FileMetadata]
    let allTags: Set<String>
}

/// Search and parse all markdown files in the given directory
/// The output will be:
/// 1. The Metadata (title / description / date) of all blog posts
/// 2. Posts html files in the output directory
struct BlogPostsBuilder {
    
    func run(searchPath: String, outputPath: String, templatesPath: String) throws -> ParsingResult  {
        print("Will search for markdown files in: \(searchPath)")
        let markdownFiles = try searchMarkdownFiles(searchPath: searchPath)
        print("Found:")
        print(markdownFiles.reduce("", { "\($0)\($1)\n"}).trimmingCharacters(in: .newlines))
        return try parseMarkdownFiles(markdownFiles: markdownFiles, templatesPath: templatesPath, outputPath: outputPath)
    }
    
    private func searchMarkdownFiles(searchPath: String) throws -> [String] {
        let markdownFiles = try FileManager.default.contentsOfDirectory(atPath: searchPath)
        return markdownFiles.map({ searchPath.appending("/" + $0) })
    }
    
    private func parseMarkdownFiles(markdownFiles: [String], templatesPath: String, outputPath: String) throws -> ParsingResult  {
        var filesMetadata: [FileMetadata] = []
        var allTags: Set<String> = Set()
        try markdownFiles.forEach { markdownFile in
            print("Starting to parse markdown file: \(markdownFile)")
            let markdownDocument = try Document(parsing: URL(fileURLWithPath: markdownFile))
            var htmlWalker = MarkdownToHtmlGen()
            htmlWalker.visit(markdownDocument)
            print("Finished parsing markdown file: \(markdownFile)")
            print("Metadata: \(htmlWalker.metadata)")
//            print("HTML: \(htmlWalker.html)")
            
            let postDate = try parseDate(string: htmlWalker.metadata.date)
            let filename = (htmlWalker.metadata.title ?? "post").toBlogPostFilename()
            let outputFile = outputPath + "/\(postDate.year)_\(postDate.month)_\(postDate.day)_\(filename).html"
            try buildPostPage(templatesPath: templatesPath, metadata: htmlWalker.metadata, markdownPostHtml: htmlWalker.html, outputFile: outputFile)
            
            filesMetadata.append(FileMetadata(file: markdownFile, outputFile: outputFile, metadata: htmlWalker.metadata))

            allTags.formUnion(Set(htmlWalker.metadata.tags))
        }
        print("All Tags: \(allTags)")
        return ParsingResult(filesMetadata: filesMetadata, allTags: allTags)
    }
    
    private func parseDate(string: String?) throws -> PostDate {
        guard let string = string else {
            throw MissingPostDate()
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: string) else {
            throw MissingPostDate()
        }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        guard
            let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day
        else {
            throw MissingPostDate()
        }
        return PostDate(year: year, month: month, day: day, date: date)
    }
    
    private func buildPostPage(templatesPath: String, metadata: Metadata, markdownPostHtml: String, outputFile: String) throws {
        let environment = Environment(loader: FileSystemLoader(paths: [Path(templatesPath)]))
        let postTemplate = try environment.loadTemplate(name: templatesPath + "/post-stencil.html")
        let context: [String: Any] = [
            "title": metadata.title ?? "",
            "date": metadata.date ?? "",
            "tags": metadata.tags,
            "post": markdownPostHtml
        ]
        let generatedPostHtml = try postTemplate.render(context)
        guard let data = generatedPostHtml.data(using: .utf8) else {
            throw NSError(domain: "StringToDataError", code: 0, userInfo: nil)
        }
        try data.write(to: URL(fileURLWithPath: outputFile))
        print("Generated post at: \(outputFile)")
        //        let context: [String: Any] = [
        //            "posts": ["post 1", "post 2", "post 3"]
        //        ]
        //        let result = try template.render(context)
        //        print("\(result)")
        //
        //        print("Index template: \(templatesPath)")
        //        print("Output: \(outputPath)")
//        if let htmlData = htmlWalker.html.data(using: .utf8) {
//            
//            let htmlFilePath = URL(fileURLWithPath: outputFile)
//            do {
//                try htmlData.write(to: htmlFilePath)
//            } catch {
//                print("Failed to write file \(htmlFilePath)")
//            }
//        }
    }
}

fileprivate extension String {
    func toBlogPostFilename() -> String {
        return self.replacingOccurrences(of: " ", with: "_").lowercased()
    }
}
