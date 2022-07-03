import ArgumentParser
import Foundation
import Markdown

struct MainRunner {
    func run() throws {
        let currentPath = ProcessInfo.processInfo.environment["RUN_PATH"] ?? FileManager.default.currentDirectoryPath
        print("Current path: \(currentPath)")
        let markdownFilesSearchPath = currentPath + "/../content"
        let templateFilesSearchPath = currentPath + "/../templates"
        let templateCssPath = templateFilesSearchPath + "/style"
        let templateImagesPath = templateFilesSearchPath + "/images"
        let outputPath = currentPath + "/../build"
        let outputCssPath = outputPath + "/style"
        let outputImagesPath = outputPath + "/images"
        
        Greeting.run()        
        let parsingResult = try BlogPostsBuilder().run(searchPath: markdownFilesSearchPath, outputPath: outputPath, templatesPath: templateFilesSearchPath)
        let sortedMetadata = sortPostsMetadata(metadata: parsingResult.filesMetadata)
        try IndexPagesBuilder(metadata: sortedMetadata, templatesPath: templateFilesSearchPath, outputPath: outputPath, postsPerPage: 4).run() //extract 4 to configuration
        TagsPageBuilder().run()
        AboutPageBuilder().run()
        // Run CopyResources for each resource folder - css / images / etc
        try CopyResources(templatesResourcesPath: templateCssPath, buildPath: outputCssPath).run()
        try CopyResources(templatesResourcesPath: templateImagesPath, buildPath: outputImagesPath).run()
                
        // Parse all blog posts
        
        // Generate each blog post html page
        // Generate index.html
        // Generate tags.html
        
               
        // Temporary
//        markdownFilesPath = "/Users/idomizrachi/dev/personal/Blog/content"
        // Temporary
//        print("Creating output directory \(outputPath)")
//        do {
//            try FileManager.default.removeItem(at: URL(fileURLWithPath: outputPath))
//        } catch {
//            print("Failed to clear output directory \(outputPath)")
//        }
//        do {
//            try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputPath), withIntermediateDirectories: true)
//        } catch {
//            print("Failed to create output directory \(outputPath)")
//        }
//        printWelcomeMessage()
//        let markdownFiles = searchMarkdownFiles()
//        try parseMarkdownFiles(markdownFiles: markdownFiles)
//    }
        
//        print("Welcome to Ido Mizrachi's static site generator")
//        print("Searching for markdown files in path: \(markdownFilesPath)")
//        print("Output path: \(outputPath)")
    }
    
//    func parseMarkdownFiles(markdownFiles: [String]) throws {
//        var allTags: Set<String> = Set()
//        print("Found the following markdown files:\n\(markdownFiles.joined(separator: "\n"))")
//        try markdownFiles.forEach { markdownFile in
//            print("Parsing \(markdownFile)")
//            guard let markdownDocument = try? Document(parsing: URL(fileURLWithPath: markdownFile)) else {
//                print("Failed to parse \(markdownFile)")
//                return
//            }
//            var htmlWalker = MarkdownToHtmlGen()
//            htmlWalker.visit(markdownDocument)
//            print("Parsing finished \(markdownFile)")
//            print("Metadata: \(htmlWalker.metadata)")
//            print("HTML: \(htmlWalker.html)")
//
//            let postDate = try parseDate(string: htmlWalker.metadata.date)
//
//            if let htmlData = htmlWalker.html.data(using: .utf8) {
//                let htmlFilePath = URL(fileURLWithPath: outputPath + "/\(postDate.year)_\(postDate.month)_\(postDate.day)_\("post").html")
//                do {
//                    try htmlData.write(to: htmlFilePath)
//                } catch {
//                    print("Failed to write file \(htmlFilePath)")
//                }
//            }
//
//            allTags.formUnion(Set(htmlWalker.metadata.tags))
//        }
//        print("All Tags: \(allTags)")
//    }
    
    func sortPostsMetadata(metadata: [FileMetadata]) -> [FileMetadata] {
        return metadata.sorted(by: { lhs, rhs in
            guard let lDate = lhs.metadata.date?.date else {
                return false
            }
            guard let rDate = rhs.metadata.date?.date else {
                return true
            }
            return  lDate > rDate
        })
    }
        
//    func parseDate(string: String?) throws -> PostDate {
//        guard let string = string else {
//            throw MissingPostDate()
//        }
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd"
//        guard let date = formatter.date(from: string) else {
//            throw MissingPostDate()
//        }
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
//        guard
//            let year = dateComponents.year,
//            let month = dateComponents.month,
//            let day = dateComponents.day
//        else {
//            throw MissingPostDate()
//        }
//        return PostDate(year: year, month: month, day: day, date: date)
//    }
}



@main
struct Main {
    static func main() throws {
        try MainRunner().run()
    }
    
}
