import Foundation
import WordPressFlux

/// A singleton providing a single point of reference to various stores.
///
class StoreContainer {
    static let shared = StoreContainer()

    private(set) var accountStore = AccountStore()
    private(set) var accountCapabilitiesStore = AccountCapabilitiesStore()
    private(set) var accountDetailsStore = AccountDetailsStore()
    private(set) var siteStore = SiteStore()
    private(set) var postStore = PostStore()
    private(set) var postListStore = PostListStore()

    private init() {}

    /// Recreates stores configured to use the specified ActionDispatcher.
    ///
    /// - Parameter dispatcher: The ActionDispatcher to use when creating the
    /// new stores.
    ///
    func resetStores(dispatcher: ActionDispatcher, site: Site?) {
        accountStore = AccountStore(dispatcher: dispatcher, accountID: site?.account.uuid)
        accountCapabilitiesStore = AccountCapabilitiesStore(dispatcher: dispatcher, siteID: site?.uuid)
        accountDetailsStore = AccountDetailsStore(dispatcher: dispatcher, accountID: site?.account.uuid)
        siteStore = SiteStore(dispatcher: dispatcher, siteID: site?.uuid)
        postStore = PostStore(dispatcher: dispatcher, siteID: site?.uuid)
        postListStore = PostListStore(dispatcher: dispatcher, siteID: site?.uuid)
    }
}
