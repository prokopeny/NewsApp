import Foundation
import UIKit
import ReadMoreTextView

extension ReadMoreTextView {
    
    func defaultValue() {
        let readMoreTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)
        ]
        let readLessTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)
        ]
        self.attributedReadMoreText = NSAttributedString(string: "...Read more", attributes: readMoreTextAttributes)
        self.attributedReadLessText = NSAttributedString(string: " Read less", attributes: readLessTextAttributes)
    }
}
