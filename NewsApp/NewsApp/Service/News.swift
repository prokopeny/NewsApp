import Foundation

struct News: Decodable {
    var articles: [Item]?
    var status: String?
    var message: String?
    var totalResults: Int?
    enum CodingKeys: String, CodingKey {
        case articles = "articles"
        case status = "status"
        case message = "message"
        case totalResults = "totalResults"
    }
}

struct Item: Decodable, Equatable {
    var author: String?
    var title: String?
    var description: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case description = "description"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
}

