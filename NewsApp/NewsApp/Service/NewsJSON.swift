import Foundation
import Alamofire

class NewsJSON {
    
    typealias newsCallBack = (_ news: News?, _ status: Bool, _ message: String) -> Void
    var callBack: newsCallBack?
    let baseUrl = "http://newsapi.org/v2/everything"
    
    func getNews(from: String, to: String, page: Int) {
        let q = "everything"
        let from = from
        let to = to
        let sortBy = "publishedAt"
        let pageSize = "27"
        let page = String(page)
        let language = "en"
        let apiKey = "25c7347865324053a99573d1c175499e"
        let params = ["q": q, "from": from, "to": to, "sortBy": sortBy, "pageSize": pageSize, "page": page, "language": language, "apiKey": apiKey]
        setRequest(params: params as [String : AnyObject])
    }
    
    func setRequest(params: [String: AnyObject]?) {
        AF.request(self.baseUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).response { (responceData) in
            guard let data = responceData.data else {
                self.callBack?(nil, false, "")
                return}
            do{
                let model = try JSONDecoder().decode(News.self, from: data)
                self.callBack?(model, true, "")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandler(callBack: @escaping newsCallBack) {
        self.callBack = callBack
    }
    
}
