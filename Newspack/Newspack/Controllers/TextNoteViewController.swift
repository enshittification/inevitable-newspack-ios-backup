import UIKit

class TextNoteViewController: UIViewController {

    @IBOutlet var textView: UITextView!

    var asset: StoryAsset?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavbar()
        configureToolbar()
        configureTextView()
        configureStyle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        saveOrDiscard()
    }

    func configureNavbar() {
        navigationItem.title = NSLocalizedString("Text Note", comment: "Noun. The title of a screen that shows the contents of a text note.")
    }

    func configureToolbar() {
        navigationController?.setToolbarHidden(true, animated: true)
    }

    func configureStyle() {
        Appearance.style(textView: textView)
        textView.textContainerInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
    }

    func configureTextView() {
        guard let note = asset else {
            return
        }
        textView.text = note.text
    }

    func saveOrDiscard() {
        if textView.text.isEmpty {
            discardNote()
        } else {
            saveNote()
        }
    }

    func discardNote() {
        guard let asset = asset else {
            return
        }
        let action = AssetAction.deleteAsset(assetID: asset.uuid)
        SessionManager.shared.sessionDispatcher.dispatch(action)
    }

    func saveNote() {
        if let _ = asset {
            updateTextNote()
        } else {
            createTextNote()
        }
    }

    func updateTextNote() {
        guard let asset = asset else {
            return
        }
        let action = AssetAction.updateText(assetID: asset.uuid, text: textView.text)
        SessionManager.shared.sessionDispatcher.dispatch(action)
    }

    func createTextNote() {
        let action = AssetAction.createAssetFor(text: textView.text)
        SessionManager.shared.sessionDispatcher.dispatch(action)
    }

}

extension TextNoteViewController: UITextViewDelegate {

}
