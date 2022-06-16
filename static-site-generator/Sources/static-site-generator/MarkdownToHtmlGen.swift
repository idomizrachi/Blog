//
//  HtmlWalker.swift
//  
//
//  Created by Ido Mizrachi on 07/06/2022.
//

import Foundation
import Markdown

struct Metadata {
    var title: String? = nil
    var subtitle: String? = nil
    var tags: [String] = []
    var date: String? = nil //YYYY-MM-dd - https://www.iso.org/iso-8601-date-and-time-format.html
}

struct MarkdownToHtmlGen: MarkupWalker {
    
    var metadata = Metadata()
    var html: String = ""
    
    var isParsingMetadata: Bool = true  // Metadata ends at the first ThematicBreak element, text is: ---
    
    
    /**
     A default implementation to use when a visitor method isn't implemented for a particular element.
     - parameter markup: the element to visit.
     - returns: The result of the visit.
     */
//    mutating func defaultVisit(_ markup: Markup) {
//
//    }

    /**
     Visit any kind of `Markup` element and return the result.

     - parameter markup: Any kind of `Markup` element.
     - returns: The result of the visit.
     */
//    mutating func visit(_ markup: Markup) {
//    }

    /**
     Visit a `BlockQuote` element and return the result.

     - parameter blockQuote: A `BlockQuote` element.
     - returns: The result of the visit.
     */
    mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
        print("block quote:\n\(blockQuote.format())")
        html.append("""
        <blockquote class="blockquote"><p>\(blockQuote.format())</p></blockquote>
        """)
    }

    /**
     Visit a `CodeBlock` element and return the result.

     - parameter codeBlock: An `CodeBlock` element.
     - returns: The result of the visit.
     */
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
        print("code block:\n\(codeBlock.code)")
        html.append("""
        <pre><code class="language-swift highlighter-rouge">
        \(codeBlock.code)
        </code></pre>
        """)
        
    }

    /**
     Visit a `CustomBlock` element and return the result.

     - parameter customBlock: An `CustomBlock` element.
     - returns: The result of the visit.
     */
    mutating func visitCustomBlock(_ customBlock: CustomBlock) {
        print("custom block:\n\(customBlock.format())")
        assertionFailure("Missing implementation")
    }

    /**
     Visit a `Document` element and return the result.

     - parameter document: An `Document` element.
     - returns: The result of the visit.
     */
//    mutating func visitDocument(_ document: Document) {
//
//    }

    /**
     Visit a `Heading` element and return the result.

     - parameter heading: An `Heading` element.
     - returns: The result of the visit.
     */
    mutating func visitHeading(_ heading: Heading) {
        print("heading:\n\(heading.plainText)")
        let level = heading.level
        html.append("""
        <h\(level)>\(heading.plainText)</h\(level)>
        """)
    }

    /**
     Visit a `ThematicBreak` element and return the result.

     - parameter thematicBreak: An `ThematicBreak` element.
     - returns: The result of the visit.
     */
    mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
        if isParsingMetadata {
            isParsingMetadata = false
            print("Finished parsing metadata \(metadata)")
        }
        print("thematic break:\n\(thematicBreak.format())")
    }
    
    /**
     Visit an `HTML` element and return the result.

     - parameter html: An `HTML` element.
     - returns: The result of the visit.
     */
    mutating func visitHTMLBlock(_ html: HTMLBlock) {
        print("html block:\n\(html.rawHTML)")
    }

    /**
     Visit a `ListItem` element and return the result.

     - parameter listItem: An `ListItem` element.
     - returns: The result of the visit.
     */
    mutating func visitListItem(_ listItem: ListItem) {
        print("\(listItem.format())")
    }

    /**
     Visit a `OrderedList` element and return the result.

     - parameter orderedList: An `OrderedList` element.
     - returns: The result of the visit.
     */
    mutating func visitOrderedList(_ orderedList: OrderedList) {
        print("orders list:\n\(orderedList.format())")
    }

    /**
     Visit a `UnorderedList` element and return the result.

     - parameter unorderedList: An `UnorderedList` element.
     - returns: The result of the visit.
     */
    mutating func visitUnorderedList(_ unorderedList: UnorderedList) {
        print("unorders list:\n\(unorderedList.format())")
    }

    /**
     Visit a `Paragraph` element and return the result.

     - parameter paragraph: An `Paragraph` element.
     - returns: The result of the visit.
     */
    mutating func visitParagraph(_ paragraph: Paragraph) {
        if isParsingMetadata {
            parseMetadataFields(paragraph: paragraph)
        } else {
            html.append("""
            <p>\(paragraph.plainText)</p>
            """)
        }
        print("paragraph:\n\(paragraph.plainText)")
    }
    
    

    /**
     Visit a `BlockDirective` element and return the result.

     - parameter blockDirective: A `BlockDirective` element.
     - returns: The result of the visit.
     */
    mutating func visitBlockDirective(_ blockDirective: BlockDirective) {
        print("block directive:\n\(blockDirective.format())")
    }

    /**
     Visit a `InlineCode` element and return the result.

     - parameter inlineCode: An `InlineCode` element.
     - returns: The result of the visit.
     */
    mutating func visitInlineCode(_ inlineCode: InlineCode) {
        print("inline code:\n\(inlineCode.plainText)")
        html.append("""
        <pre><code class="language-swift highlighter-rouge">\(inlineCode.plainText)</code></pre>
        """)
    }

    /**
     Visit a `CustomInline` element and return the result.

     - parameter customInline: An `CustomInline` element.
     - returns: The result of the visit.
     */
    mutating func visitCustomInline(_ customInline: CustomInline) {
        print("custom inline:\n\(customInline.plainText)")
    }

    /**
     Visit a `Emphasis` element and return the result.

     - parameter emphasis: An `Emphasis` element.
     - returns: The result of the visit.
     */
    mutating func visitEmphasis(_ emphasis: Emphasis) {
        print("emphasis:\n\(emphasis.plainText)")
    }

    /**
     Visit a `Image` element and return the result.

     - parameter image: An `Image` element.
     - returns: The result of the visit.
     */
    mutating func visitImage(_ image: Image) {
        print("image:\n\(image.plainText)")
    }

    /**
     Visit a `InlineHTML` element and return the result.

     - parameter inlineHTML: An `InlineHTML` element.
     - returns: The result of the visit.
     */
    mutating func visitInlineHTML(_ inlineHTML: InlineHTML) {
        print("inline html:\n\(inlineHTML.plainText)")
    }

    /**
     Visit a `LineBreak` element and return the result.

     - parameter lineBreak: An `LineBreak` element.
     - returns: The result of the visit.
     */
    mutating func visitLineBreak(_ lineBreak: LineBreak) {
        print("line break:\n\(lineBreak.plainText)")
    }

    /**
     Visit a `Link` element and return the result.

     - parameter link: An `Link` element.
     - returns: The result of the visit.
     */
    mutating func visitLink(_ link: Link) {
        print("link:\n\(link.plainText)")
    }
    
    /**
     Visit a `SoftBreak` element and return the result.

     - parameter softBreak: An `SoftBreak` element.
     - returns: The result of the visit.
     */
    mutating func visitSoftBreak(_ softBreak: SoftBreak) {
        print("soft break:\n\(softBreak.plainText)")
    }
    /**
     Visit a `Strong` element and return the result.

     - parameter strong: An `Strong` element.
     - returns: The result of the visit.
     */
    mutating func visitStrong(_ strong: Strong) {
        print("strong:\n\(strong.plainText)")
    }

    /**
     Visit a `Text` element and return the result.

     - parameter text: A `Text` element.
     - returns: The result of the visit.
     */
    mutating func visitText(_ text: Text) {
        print("text:\n\(text.plainText)")
    }
    

    /**
     Visit a `Strikethrough` element and return the result.

     - parameter strikethrough: A `Strikethrough` element.
     - returns: The result of the visit.
     */
    mutating func visitStrikethrough(_ strikethrough: Strikethrough) {
        print("strike through:\n\(strikethrough.plainText)")
    }

    /**
     Visit a `Table` element and return the result.

     - parameter table: A `Table` element.
     - returns: The result of the visit.
     */
    mutating func visitTable(_ table: Table) {
        print("table:\n\(table.format())")
    }

    /**
     Visit a `Table.Head` element and return the result.

     - parameter tableHead: A `Table.Head` element.
     - returns: The result of the visit.
     */
    mutating func visitTableHead(_ tableHead: Table.Head) {
        print("table head:\n\(tableHead.format())")
    }

    /**
     Visit a `Table.Body` element and return the result.

     - parameter tableBody: A `Table.Body` element.
     - returns: The result of the visit.
     */
    mutating func visitTableBody(_ tableBody: Table.Body) {
        print("table body:\n\(tableBody.format())")
    }

    /**
     Visit a `Table.Row` element and return the result.

     - parameter tableRow: A `Table.Row` element.
     - returns: The result of the visit.
     */
    mutating func visitTableRow(_ tableRow: Table.Row) {
        print("table row:\n\(tableRow.format())")
    }

    /**
     Visit a `Table.Cell` element and return the result.

     - parameter tableCell: A `Table.Cell` element.
     - returns: The result of the visit.
     */
    mutating func visitTableCell(_ tableCell: Table.Cell) {
        print("table cell:\n\(tableCell.plainText)")
    }

    /**
     Visit a `SymbolLink` element and return the result.

     - parameter symbolLink: A `SymbolLink` element.
     - returns: The result of the visit.
     */
    mutating func visitSymbolLink(_ symbolLink: SymbolLink) {
        print("symbol link:\n\(symbolLink.plainText)")
    }
        
    private mutating func parseMetadataFields(paragraph: Paragraph) {
//        if paragraph.plainText.hasPrefix("title: ") {
//            let titleHeaderCount = "title: ".count
//            let skipTitleHeader = paragraph.plainText.index(paragraph.plainText.startIndex, offsetBy: titleHeaderCount)
//            title = String(paragraph.plainText[skipTitleHeader...]).trimmingCharacters(in: .whitespacesAndNewlines)
//        }
        if let title = parseMetadataField(header: "title", paragraph: paragraph) {
            self.metadata.title = title
        }
        
//        if paragraph.plainText.hasPrefix("tags: ") {
//            let tagsHeaderCount = "tags: ".count
//            let skipTagsHeader = paragraph.plainText.index(paragraph.plainText.startIndex, offsetBy: tagsHeaderCount)
//            tags = String(paragraph.plainText[skipTagsHeader...]).split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
//        }
        if let tags = parseMetadataField(header: "tags", paragraph: paragraph) {
            self.metadata.tags = tags.split(separator: ",").map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        if let date = parseMetadataField(header: "date", paragraph: paragraph) {
            self.metadata.date = date
        }
        
        if let subtitle = parseMetadataField(header: "subtitle", paragraph: paragraph) {
            self.metadata.subtitle = subtitle
        }
    }
    
    private func parseMetadataField(header: String, paragraph: Paragraph) -> String? {
        guard paragraph.plainText.hasPrefix("\(header): ") else {
            return nil
        }
        let headerCharactersCount = "\(header): ".count
        let skipHeader = paragraph.plainText.index(paragraph.plainText.startIndex, offsetBy: headerCharactersCount)
        return String(paragraph.plainText[skipHeader...])
    }
}
