import Alamofire
import Moya
import Foundation

enum NetworkAPI{
    
    case search(page : Int)
    
}


extension NetworkAPI : TargetType {
    //BaseURL
    var baseURL: URL {
        switch self {
        default :
            return URL(string: "https://www.gccompany.co.kr/App")!
        }
    }
    
    
    var headers: [String: String]? {
        return .none
    }
    
    //경로
    var path: String {
        switch self {
        case .search(let page) :
            return "/json/\(page).json"
        }
    }
    //통신을 get , post , put 등 무엇으로 할지 이곳에서 결정한다 값이 없다면 디폴트로 Get을 요청
    var method : Moya.Method {
        switch self {
        default :
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .search :
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .search(let page ) :
            return stubbedResponse("Search\(page)")
        }
    }
    
    
    
    func stubbedResponse(_ filename: String) -> Data! {
        let bundlePath = Bundle.main.path(forResource: "Json", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        let path = bundle?.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
    
    
    
}


