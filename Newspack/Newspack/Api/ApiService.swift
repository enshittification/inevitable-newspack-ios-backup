import Foundation

/// Convenience class providing factory methods for creating remotes.
///
class ApiService {

    /// Singleon reference
    ///
    static let shared = ApiService()

    private init() {}

    /// Get an instance of the UserServiceRemote
    ///
    /// - Returns: UserServiceRemote
    func userServiceRemote() -> UserServiceRemote {
        let api = SessionManager.shared.api
        return UserServiceRemote(wordPressComRestApi: api)
    }

    /// Get an instance of the SiteServiceRemote
    ///
    /// - Returns: SiteServiceRemote
    func siteServiceRemote() -> SiteServiceRemote {
        let api = SessionManager.shared.api
        return SiteServiceRemote(wordPressComRestApi: api)
    }

    /// Get an instance of the PostServiceRemote
    ///
    /// - Returns: PostServiceRemote
    func postServiceRemote() -> PostServiceRemote {
        let api = SessionManager.shared.api
        return PostServiceRemote(wordPressComRestApi: api)
    }
}