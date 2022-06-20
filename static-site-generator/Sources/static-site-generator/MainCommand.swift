import ArgumentParser
import Markdown
import Foundation

struct PostDate {
    let year: Int
    let month: Int
    let day: Int
    let date: Date
}

struct MissingPostDate: Error {}

struct MainCommand: ParsableCommand {
    
    @Argument(help: "The path containing the markdown files")
    var markdownFilesPath: String = FileManager.default.currentDirectoryPath + "/markdown"
    
    @Option(help: "Output path for the generated site")
    var outputPath: String = FileManager.default.currentDirectoryPath + "/output"
    
    mutating func run() throws {
        
        // Temporary
        markdownFilesPath = "/Users/idomizrachi/dev/personal/Blog/content"
        // Temporary
        print("Creating output directory \(outputPath)")
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: outputPath))
        } catch {
            print("Failed to clear output directory \(outputPath)")
        }
        do {
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputPath), withIntermediateDirectories: true)
        } catch {
            print("Failed to create output directory \(outputPath)")
        }
        printWelcomeMessage()
        let markdownFiles = searchMarkdownFiles()
        try parseMarkdownFiles(markdownFiles: markdownFiles)
    }
    
    func printWelcomeMessage() {
        print("Welcome to Ido Mizrachi's static site generator")
        print("Searching for markdown files in path: \(markdownFilesPath)")
        print("Output path: \(outputPath)")
    }
    
    func parseMarkdownFiles(markdownFiles: [String]) throws {
        var allTags: Set<String> = Set()
        print("Found the following markdown files:\n\(markdownFiles.joined(separator: "\n"))")
        try markdownFiles.forEach { markdownFile in
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
            
            let postDate = try parseDate(string: htmlWalker.metadata.date)
            
            if let htmlData = htmlWalker.html.data(using: .utf8) {
                let htmlFilePath = URL(fileURLWithPath: outputPath + "/\(postDate.year)_\(postDate.month)_\(postDate.day)_\("post").html")
                do {
                    try htmlData.write(to: htmlFilePath)
                } catch {
                    print("Failed to write file \(htmlFilePath)")
                }
            }
            
            allTags.formUnion(Set(htmlWalker.metadata.tags))
        }
        print("All Tags: \(allTags)")
    }
    
    func parseDate(string: String?) throws -> PostDate {
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
