import Foundation
import WordPressFlux
import Gutenberg
import Aztec

/// Provides a bridge between the Editor, and the content being edited.
///
class EditCoordinator: Store {

    var postItem: PostListItem?
    let stagedEdits: StagedEdits

    init(postItem: PostListItem?, dispatcher: ActionDispatcher) {
        self.postItem = postItem
        self.stagedEdits = postItem?.stagedEdits ?? StagedEdits(context: CoreDataManager.shared.mainContext)
        super.init(dispatcher: dispatcher)
    }

    override func onDispatch(_ action: Action) {
        guard let editAction = action as? EditAction else {
            return
        }

        switch editAction {
        case .autosave(let title, let content):
            handleAutosave(title: title, content: content)
        case .stageChanges(let title, let content):
            handleStageChanges(title: title, content: content)
        }
    }

    func handleStageChanges(title: String, content: String) {
        stagedEdits.title = title
        stagedEdits.content = content

        CoreDataManager.shared.saveContext()
    }

    func handleAutosave(title: String, content: String) {
        // TODO: check for changes. If no changes bail.

        if postItem == nil {
            // This is either the first autosave.
            // create post list item
            // TODO:
        }

        // Try to autosave changes.
        let title = stagedEdits.title ?? ""
        let content = stagedEdits.content ?? ""
        let postService = ApiService.shared.postServiceRemote()
        postService.autosave(postID: 1, title: title, content: content)
    }

}

extension EditCoordinator: GutenbergBridgeDataSource {
    func gutenbergInitialContent() -> String? {
        if
            let edits = postItem?.stagedEdits,
            let content = edits.content
        {
            return content
        }
        return postItem?.post?.content ?? ""
    }

    func gutenbergInitialTitle() -> String? {
        if
            let edits = postItem?.stagedEdits,
            let title = edits.title
        {
            return title
        }
        return postItem?.post?.title ?? ""
    }

    func aztecAttachmentDelegate() -> TextViewAttachmentDelegate {
        return EditorAttachmentDelegate()
    }

    func gutenbergLocale() -> String? {
        // TODO: Use system locale
        return "en"
    }

    func gutenbergTranslations() -> [String : [String]]? {
        return nil
    }
}
