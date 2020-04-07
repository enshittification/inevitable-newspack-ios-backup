import Foundation
import WordPressFlux

/// Responsible for managing folder related things.
///
class FolderStore: Store {

    private(set) var currentSiteID: UUID?

    private let folderManager: FolderManager

    init(dispatcher: ActionDispatcher = .global, siteID: UUID? = nil) {
        currentSiteID = siteID

        let rootFolder = Environment.isTesting() ? FolderManager.createTemporaryDirectory() : nil
        folderManager = FolderManager(rootFolder: rootFolder)

        if
            let siteID = siteID,
            let site = StoreContainer.shared.siteStore.getSiteByUUID(siteID),
            let title = site.title
        {
            let sanitizedTitle = title.replacingOccurrences(of: "/", with: "-")
            guard let url = folderManager.createFolderAtPath(path: sanitizedTitle) else {
                fatalError("Unable to create a folder named: \(sanitizedTitle)")
            }
            guard folderManager.setCurrentFolder(url: url) else {
                fatalError("Unable to set the current working folder to \(url.path)")
            }
        }

        super.init(dispatcher: dispatcher)
    }

    /// Action handler
    ///
    override func onDispatch(_ action: Action) {
        if let action = action as? FolderAction {
            switch action {
            case .createFolder(let path, let addSuffix) :
                createFolder(path: path, addSuffix: addSuffix)
            case .renameFolder(let folder, let name) :
                renameFolder(at: folder, to: name)
            }
        }
    }
}

extension FolderStore {

    func createFolder(path: String, addSuffix: Bool) {
        if let url = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: addSuffix) {
            LogDebug(message: "Success: \(url.path)")
            emitChange()
        }
    }

    func renameFolder(at url: URL, to name: String) {
        if folderManager.renameFolder(at: url, to: name) {
            emitChange()
        }
    }

    func listFolders() -> [URL] {
        return folderManager.enumerateFolders(url: folderManager.currentFolder)
    }

}
