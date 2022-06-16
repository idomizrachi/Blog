import ArgumentParser
import Markdown
import Foundation


struct MainCommand: ParsableCommand {
    
    @Argument(help: "The path containing the markdown files")
    var markdownFilesPath: String = FileManager.default.currentDirectoryPath + "/markdown"
    
    @Option(help: "Output path for the generated site")
    var outputPath: String = FileManager.default.currentDirectoryPath + "/output"
    
    mutating func run() throws {
        
        // Temporary
        markdownFilesPath = "/Users/idomizrachi/dev/personal/Blog/content"
        // Temporary
        printWelcomeMessage()
        let markdownFiles = searchMarkdownFiles()
        parseMarkdownFiles(markdownFiles: markdownFiles)
    }
    
    func printWelcomeMessage() {
        print("Welcome to Ido Mizrachi's static site generator")
        print("Searching for markdown files in path: \(markdownFilesPath)")
        print("Output path: \(outputPath)")
    }
    
    func parseMarkdownFiles(markdownFiles: [String]) {
        var allTags: Set<String> = Set()
        print("Found the following markdown files:\n\(markdownFiles.joined(separator: "\n"))")
        markdownFiles.forEach { markdownFile in
            print("Parsing \(markdownFile)")
            guard let markdownDocument = try? Document(parsing: URL(fileURLWithPath: markdownFile)) else {
                print("Failed to parse \(markdownFile)")
                return
            }
            var htmlWalker = MarkdownToHtmlGen()
            htmlWalker.visit(markdownDocument)
            print("Parsing finished \(markdownFile)")
            print("Metadata: \(htmlWalker.metadata)")
            print("HTML: \(htmlWalker.html)")
            allTags.formUnion(Set(htmlWalker.metadata.tags))
        }
        print("All Tags: \(allTags)")
    }
    
    func searchMarkdownFiles() -> [String] {
        guard let pathEnumerator: EnumeratedSequence<FileManager.DirectoryEnumerator> = FileManager.default.enumerator(atPath: markdownFilesPath)?.enumerated() else {
            return []
        }
        let markdownFiles = pathEnumerator.map(\.element) as? [String] ?? []
        return markdownFiles.map({ markdownFilesPath.appending("/" + $0) })
    }
}

@main
struct Main {
    static func main() {
        MainCommand.main()
    }
    
}
