import UIKit
import SDWebImage
import ReadMoreTextView
import AudioToolbox

class NewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var newsTableView: UITableView!{
        didSet {
            newsTableView.estimatedRowHeight = 140
            newsTableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    let service = NewsJSON()
    let sevenDaysInSec = 604800
    let date = NSDate()
    let helper = Helper()
    let alertView = AlertView.instanceFromNib()
    var refreshDate = NSDate()
    var currentPage = 1
    var refreshControl = UIRefreshControl()
    var isRefresh = false
    var isLoading = false
    var filterArray = News()
    var newsArray = News()
    var expandedCells = Set<Int>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews(fromDate: date, toDate: date)
        self.navigationController?.navigationBar.isHidden = true
        createPullToRefresh()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        newsTableView.reloadData()
    }
    
    // MARK: - UI
    
    private func setupViews() {
        setupTableViews()
        setupSearchBar()
    }
    
    private func setupTableViews() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    // MARK: - IBActions
    
    func getFromDate(_ date: NSDate) -> String {
        let currentDateInSec = Int(date.timeIntervalSince1970)
        return convertToNewsAPIDate(unixTime: currentDateInSec)!
    }
    
    func getToDate(_ date: NSDate) -> String {
        let toDateInSec = Int(date.timeIntervalSince1970) - sevenDaysInSec
        return convertToNewsAPIDate(unixTime: toDateInSec)!
    }
    
    func convertToNewsAPIDate(unixTime: Int) -> String? {
        let timeInSecond = TimeInterval(unixTime)
        let newsDate = Date(timeIntervalSince1970: timeInSecond)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss Z"
        return "\(dateFormatter.string(from: newsDate))"
    }

    func getNews(fromDate: NSDate, toDate: NSDate) {
        service.getNews(from: getFromDate(fromDate), to: getToDate(toDate), page: currentPage)
        service.completionHandler { [weak self](news, status, message) in
            if status {
                guard let self = self else {return}
                guard let list = news else {return}
                self.newsArray = list
                self.filterArray = list
                self.newsTableView.reloadData()
            }}
    }
    
    func getNextPage(fromDate: NSDate, toDate: NSDate) {
        isLoading = true
        currentPage += 1
        service.getNews(from: getFromDate(fromDate), to: getToDate(toDate), page: currentPage)
        complition()
    }
    
    func complition() {
        service.completionHandler { [weak self](news, status, message) in
            if status {
                guard let self = self else {return}
                guard let list = news else {return}
                if news?.status == "ok" {
                    if list.articles == [] {
                        self.createAlert(errorName: "all item on this time")
                    } else {
                        self.newsArray.articles! += list.articles!
                        self.newsTableView.reloadData()
                        self.isLoading = false
                    }
                } else {
                    self.createAlert(errorName: (news?.message)!)
                }} else {
                self?.createAlert(errorName: "Error, Not connection to the internet")
            }}
    }
    
    func createPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        isRefresh = true
        currentPage = 1
        let currentDate = NSDate()
        self.refreshDate = currentDate
        service.getNews(from: getFromDate(currentDate), to: getToDate(currentDate), page: currentPage)
        service.completionHandler { [weak self](news, status, message) in
            if status {
                guard let self = self else {return}
                guard let list = news else {return}
                self.newsArray = list
                self.newsTableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                self?.createAlert(errorName: "Error, Not connection to the internet")
            }}
    }
    
    func createAlert(errorName: String) {
        alertView.frame = self.view.frame
        self.alertView.mainView.alpha = 1
        alertView.blur.alpha = 0.7
        alertView.mainView.viewBorder(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        alertView.okButton.viewBorder(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.alertView.mainView.frame.origin.x -= 10
        }) { (true) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.alertView.mainView.frame.origin.x += 20
            }) { (true) in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                    self.alertView.mainView.frame.origin.x -= 10
                })
            }
        }
        alertView.errorTextView.text = errorName
        alertView.errorTextViewHeightConstraint.constant = helper.getContentSizeHeight(alertView.errorTextView)
        view.addSubview(alertView)
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
        readMoreTextView.text = newsArray.articles?[indexPath.row].description
        readMoreTextView.shouldTrim = !expandedCells.contains(indexPath.row)
        readMoreTextView.setNeedsUpdateTrim()
        readMoreTextView.layoutIfNeeded()
        readMoreTextView.defaultValue()
        cell.itemAuthorLabel.text = newsArray.articles?[indexPath.row].author
       
        if let url = URL(string: newsArray.articles?[indexPath.row].urlToImage ?? "") {
            cell.itemImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "no_Photo"), options: [.continueInBackground, .progressiveLoad], completed: nil)
        }
        cell.itemDateLabel.text = helper.convertISODateToDate(isoDate: (newsArray.articles?[indexPath.row].publishedAt)!)
        cell.itemImageView.roundCorners(radius: 5)
        cell.mainView.roundCorners(radius: 5)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // for readMoreTextView
        let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
        readMoreTextView.onSizeChange = { [unowned tableView, unowned self] r in
            let point = tableView.convert(r.bounds.origin, from: r)
            guard let indexPath = tableView.indexPathForRow(at: point) else { return }
            if r.shouldTrim {
                self.expandedCells.remove(indexPath.row)
            } else {
                self.expandedCells.insert(indexPath.row)
            }
            tableView.reloadData()
        }
        //    for pagination
        let lastItemIndex = newsArray.articles!.count - 1
        if indexPath.row == lastItemIndex {
            if isLoading == false {
                if isRefresh == false {
                    getNextPage(fromDate: date, toDate: date)
                } else {
                    getNextPage(fromDate: refreshDate, toDate: refreshDate)
                }}
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailNewsViewController") as? DetailNewsViewController else {
            return
        }
        vc.detailNews = newsArray.articles?[indexPath.row] as! Item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isLoading = true
        refreshControl.removeFromSuperview()
        if searchText.isEmpty {
            newsArray.articles = filterArray.articles
            createPullToRefresh()
            isLoading = false
        } else {
            newsArray.articles = newsArray.articles?.filter({ (mod) -> Bool in
                return (mod.description?.lowercased().contains(searchText.lowercased()) ?? true)
            })
        }
        self.newsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        newsArray.articles = filterArray.articles
        createPullToRefresh()
        isLoading = false
        newsTableView.reloadData()
    }
    
}
