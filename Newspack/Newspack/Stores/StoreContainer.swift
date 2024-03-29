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
    private(set) var postItemStore = PostItemStore()
    private(set) var mediaStore = MediaStore()
    private(set) var mediaItemStore = MediaItemStore()
    private(set) var imageStore = ImageStore()
    private(set) var stagedMediaStore = StagedMediaStore()
    private(set) var folderStore = FolderStore()

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
        postItemStore = PostItemStore(dispatcher: dispatcher, siteID: site?.uuid)
        mediaStore = MediaStore(dispatcher: dispatcher, siteID: site?.uuid)
        mediaItemStore = MediaItemStore(dispatcher: dispatcher, siteID: site?.uuid)
        imageStore = ImageStore(dispatcher: dispatcher)
        stagedMediaStore = StagedMediaStore(dispatcher: dispatcher, siteID: site?.uuid)
        folderStore = FolderStore(dispatcher: dispatcher, siteID: site?.uuid)
    }
}
