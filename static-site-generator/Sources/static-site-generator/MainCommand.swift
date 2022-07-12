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
        do {
            print("Creating build folder")
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputPath), withIntermediateDirectories: true)
            print("Creating build/style folder")
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputCssPath), withIntermediateDirectories: true)
            print("Creating build/images folder")
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputImagesPath), withIntermediateDirectories: true)
        } catch {
        }
        print("Parsing blog posts")
        let parsingResult = try BlogPostsBuilder().run(searchPath: markdownFilesSearchPath, outputPath: outputPath, templatesPath: templateFilesSearchPath)
        print("Parsing blog posts - finished")
        print("Sorting blog posts")
        let sortedMetadata = sortPostsMetadata(metadata: parsingResult.filesMetadata)
        print("Sorting blog posts - finished")
        print("Creating index page")
//        try IndexPagesBuilder(metadata: sortedMetadata, templatesPath: templateFilesSearchPath, outputPath: outputPath, postsPerPage: 4).run() //extract 4 to configuration
//        print("Creating index page - finished")
//        TagsPageBuilder().run()
//        AboutPageBuilder().run()
        // Run CopyResources for each resource folder - css / images / etc
        print("Copyinh css from \(templateCssPath) to \(outputCssPath)")
        try CopyResources(templatesResourcesPath: templateCssPath, buildPath: outputCssPath).run()
        print("Copying images from \(templateImagesPath) to \(outputImagesPath)")
        try CopyResources(templatesResourcesPath: templateImagesPath, buildPath: outputImagesPath).run()
                        
    }
    
    
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
}



@main
struct Main {
    static func main() throws {
        try MainRunner().run()
    }
    
}
