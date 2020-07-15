import UIKit
import ReadMoreTextView

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var descriptionReadMoreTextView: ReadMoreTextView!
    @IBOutlet weak var itemAuthorLabel: UILabel!
    @IBOutlet weak var itemDateLabel: UILabel!

    override func prepareForReuse() {
           super.prepareForReuse()
           descriptionReadMoreTextView.onSizeChange = { _ in }
           descriptionReadMoreTextView.shouldTrim = true
       }
    
}
