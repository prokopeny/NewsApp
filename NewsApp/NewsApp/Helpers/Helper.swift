import Foundation
import UIKit

class Helper {
    
    func convertISODateToDate(isoDate: String) -> String {
        let fromDateFormatter = DateFormatter()
        let toDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        toDateFormatter.dateFormat = "MMM d, h:mm a"
        let date = fromDateFormatter.date(from: isoDate)!
        toDateFormatter.string(from: date)
        return toDateFormatter.string(from: date)
    }
    
    func getContentSizeHeight(_ textView: UITextView) -> CGFloat {
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        return contentSize.height
    }
}
