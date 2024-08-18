import Foundation

public class HTMLToMarkdownConverter {
    public init() {}
    
    public func convert(_ html: String) -> String {
        var markdown = html
        
        // Convert headers
        markdown = convertHeaders(markdown)
        
        // Convert bold and italic
        markdown = convertBoldAndItalic(markdown)
        
        // Convert links
        markdown = convertLinks(markdown)
        
        // Convert lists
        markdown = convertLists(markdown)
        
        // Remove any remaining HTML tags
        markdown = removeHTMLTags(markdown)
        
        return markdown
    }
    
    private func convertHeaders(_ text: String) -> String {
        var result = text
        for i in (1...6).reversed() {
            let pattern = "<h\(i)>(.*?)</h\(i)>"
            let replacement = String(repeating: "#", count: i) + " $1"
            result = result.replacingOccurrences(of: pattern, with: replacement, options: .regularExpression)
        }
        return result
    }
    
    private func convertBoldAndItalic(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "<b>(.*?)</b>", with: "**$1**", options: .regularExpression)
        result = result.replacingOccurrences(of: "<i>(.*?)</i>", with: "*$1*", options: .regularExpression)
        return result
    }
    
    private func convertLinks(_ text: String) -> String {
        let pattern = "<a href=\"(.*?)\">(.*?)</a>"
        return text.replacingOccurrences(of: pattern, with: "[$2]($1)", options: .regularExpression)
    }
    
    private func convertLists(_ text: String) -> String {
        var result = text
        // Unordered lists
        result = result.replacingOccurrences(of: "<ul>(.*?)</ul>", with: "$1", options: [.regularExpression])
        result = result.replacingOccurrences(of: "<li>(.*?)</li>", with: "- $1\n", options: .regularExpression)
        
        // Ordered lists
        result = result.replacingOccurrences(of: "<ol>(.*?)</ol>", with: "$1", options: [.regularExpression])
        result = result.replacingOccurrences(of: "<li>(.*?)</li>", with: "1. $1\n", options: .regularExpression)
        
        return result
    }
    
    private func removeHTMLTags(_ text: String) -> String {
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
