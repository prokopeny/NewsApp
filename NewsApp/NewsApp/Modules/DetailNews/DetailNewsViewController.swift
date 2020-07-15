import UIKit

class DetailNewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    // MARK: - Properties
    
    let helper = Helper()
    var detailNews = Item()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupViews()
    }
    
    // MARK: - UI
    
    private func setupViews() {
        mainView.roundCorners(radius: 10)
        setupImageViews()
        setupTextViews()
        
    }
    
    private func setupTextViews() {
        descriptionTextView.text = detailNews.description
        contentTextView.text = detailNews.content
        authorLabel.text = detailNews.author
        dateLabel.text = helper.convertISODateToDate(isoDate: detailNews.publishedAt!)
        descriptionHeightConstraint.constant = helper.getContentSizeHeight(descriptionTextView)
        contentHeightConstraint.constant = helper.getContentSizeHeight(contentTextView)
    }
    
    private func setupImageViews() {
        if let url = URL(string: detailNews.urlToImage ?? "") {
            newsImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "no_Photo"), options: [.continueInBackground, .progressiveLoad], completed: nil)
        }
        newsImageView.roundCorners(radius: 10)
    }
    
    
    
}
