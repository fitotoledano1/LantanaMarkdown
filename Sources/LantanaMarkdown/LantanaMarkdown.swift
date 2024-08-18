import Foundation

public class HTMLToMarkdownConverter {
    public init() {}
    
    public func convert(_ html: String) -> String {
        var markdown = html
        markdown = convertHeaders(markdown)
        markdown = convertBold(markdown)
        markdown = convertItalic(markdown)
        markdown = convertLinks(markdown)
        markdown = convertLists(markdown)
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
    
    private func convertBold(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "<b>(.*?)</b>", with: "**$1**", options: .regularExpression)
        return result
    }
    
    private func convertItalic(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "<i>(.*?)</i>", with: "*$1*", options: .regularExpression)
        return result
    }
    
    private func convertLinks(_ text: String) -> String {
        let pattern = "<a href=\"(.*?)\">(.*?)</a>"
        return text.replacingOccurrences(of: pattern, with: "[$2]($1)", options: .regularExpression)
    }
    
    private func convertLists(_ text: String) -> String {
        var result = text
        
        // Convert unordered lists
        while let range = result.range(of: "<ul>.*?</ul>", options: .regularExpression) {
            let ulContent = String(result[range])
            let convertedUl = ulContent.replacingOccurrences(of: "<li>(.*?)</li>", with: "- $1\n", options: .regularExpression)
            result = result.replacingCharacters(in: range, with: convertedUl)
        }
        
        // Convert ordered lists
        while let range = result.range(of: "<ol>.*?</ol>", options: .regularExpression) {
            let olContent = String(result[range])
            let convertedOl = olContent.replacingOccurrences(of: "<li>(.*?)</li>", with: "1. $1\n", options: .regularExpression)
            result = result.replacingCharacters(in: range, with: convertedOl)
        }
        
        // Remove remaining list tags
        result = result.replacingOccurrences(of: "</?[ou]l>", with: "", options: .regularExpression)
        
        return result
    }
    
    private func removeHTMLTags(_ text: String) -> String {
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
