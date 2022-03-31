




final class UserDefaultsManager : UserDefaultsManagerProtocl{
   
    
    
    static let shared: UserDefaultsManager =  UserDefaultsManager()

    @Storage(key: USER_KEY.FavoriteAddList.rawValue, defaultValue : [])
    var favoriteList : Accommodations
 
}

final class UserDefaultsMockManager : UserDefaultsManagerProtocl{
    
   
    static let shared: UserDefaultsManager =  UserDefaultsManager()

    
    @Storage(key: USER_KEY.FavoriteMockList.rawValue, defaultValue : [])
    var favoriteList : Accommodations
    
}


