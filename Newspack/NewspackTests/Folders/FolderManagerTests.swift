import XCTest
@testable import Newspack

class FolderManagerTests: XCTestCase {

    var folderManager: FolderManager!

    override func setUpWithError() throws {
        let tempDirectory = FolderManager.createTemporaryDirectory()
        folderManager = FolderManager(rootFolder: tempDirectory)
    }

    func testCreateFolder() {
        let path = "TestFolder"
        guard let url = folderManager.createFolderAtPath(path: path) else {
            XCTFail("URL is expected to not be nil")
            return
        }

        XCTAssertNotNil(url)
        XCTAssertTrue(url.lastPathComponent.hasSuffix(path))
        XCTAssertTrue(folderManager.folderExists(url: url))
    }

    func testCreatingExistingFolder() {
        let path = "TestFolder"
        let expectedPath2 = "TestFolder 2"
        let expectedPath3 = "TestFolder 3"

        // Create the starting folder
        _ = folderManager.createFolderAtPath(path: path)

        guard let url2 = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true) else {
            XCTFail("URL is expected to not be nil")
            return
        }

        XCTAssertNotNil(url2)
        XCTAssertTrue(url2.lastPathComponent.hasSuffix(expectedPath2))
        XCTAssertTrue(folderManager.folderExists(url: url2))


        guard let url3 = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true) else {
            XCTFail("URL is expected to not be nil")
            return
        }

        XCTAssertNotNil(url3)
        XCTAssertTrue(url3.lastPathComponent.hasSuffix(expectedPath3))
        XCTAssertTrue(folderManager.folderExists(url: url3))
    }

    func testSetCurrentFolder() {
        let path = "TestFolder"

        let originalCurrentFolder = folderManager.currentFolder

        // Create the starting folder
        let url = folderManager.createFolderAtPath(path: path)!
        var success = folderManager.setCurrentFolder(url: url)
        XCTAssertTrue(success)

        success = folderManager.setCurrentFolder(url: originalCurrentFolder)
        XCTAssertTrue(success)

        success = folderManager.setCurrentFolder(url: FileManager.default.temporaryDirectory)
        XCTAssertFalse(success)
    }

    func testListFolders() {
        let path = "TestFolder"

        var folders = folderManager.enumerateFolders(url: folderManager.currentFolder)
        XCTAssertEqual(folders.count, 0)

        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)
        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)
        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)
        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)

        folders = folderManager.enumerateFolders(url: folderManager.currentFolder)
        XCTAssertEqual(folders.count, 4)
    }

    func testMoveFolder() {
        let path = "TestFolder"
        let newPath = "MovedFolder"
        let invalidPath = " "
        let url = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)!
        let childURL = url.appendingPathComponent(newPath, isDirectory: true)
        let newURL = url.deletingLastPathComponent().appendingPathComponent(newPath, isDirectory: true)
        let invalidURL = url.deletingLastPathComponent().appendingPathComponent(invalidPath, isDirectory: true)

        // Should return false if the folder name is invalid
        XCTAssertFalse(folderManager.moveFolder(at: url, to: invalidURL))

        // Should return false if the urls are the same
        XCTAssertFalse(folderManager.moveFolder(at: url, to: url))

        // Should return false if trying to make the folder a child of itself.
        XCTAssertFalse((folderManager.moveFolder(at: url, to: childURL)))

        // Should succeed moving folder to a sibling location.
        XCTAssertTrue(folderManager.moveFolder(at: url, to: newURL))

        // Original folder should no longer exist
        XCTAssertFalse(folderManager.folderExists(url: url))

        // New folder should exist
        XCTAssertTrue(folderManager.folderExists(url: newURL))

        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)!

        // Should return false if there is already a folder.
        XCTAssertFalse(folderManager.moveFolder(at: newURL, to: url))
    }

    func testRenameFolder() {
        let path = "TestFolder"
        let newName = "RenamedFolder"

        let folder = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)!
        guard let renamedFolder = folderManager.renameFolder(at: folder, to: newName) else {
            XCTFail("The renamed folder's URL should not be nil.")
            return
        }

        XCTAssertFalse(folderManager.folderExists(url: folder))
        XCTAssertTrue(folderManager.folderExists(url: renamedFolder))
    }

    func testDeleteFolder() {
        let path = "TestFolder"
        let folder = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)!

        // We should not delete folders not contained by our root folder.
        var result = folderManager.deleteFolder(at: FolderManager.createTemporaryDirectory()!)
        XCTAssertFalse(result)

        // We should delete a cihld of the root folder.
        result = folderManager.deleteFolder(at: folder)
        XCTAssertTrue(result)

        // We should not delete a non-existant folder.
        result = folderManager.deleteFolder(at: folder)
        XCTAssertFalse(result)
    }

    func testListFolderContents() {
        let parent = "ParentFolder"
        let url = folderManager.createFolderAtPath(path: parent, ifExistsAppendSuffix: true)!

        let path = "ParentFolder/TestFolder"
        var items = folderManager.enumerateFolderContents(url: url)
        XCTAssertEqual(items.count, 0)

        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)
        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)
        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)
        _ = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)

        items = folderManager.enumerateFolderContents(url: url)
        XCTAssertEqual(items.count, 4)
    }

    func testFolderContainsChild() {
        let path = "TestFolder"
        let url = folderManager.createFolderAtPath(path: path, ifExistsAppendSuffix: true)!
        let failURL = FolderManager.createTemporaryDirectory()!

        XCTAssertTrue(folderManager.folder(folderManager.currentFolder, contains: url))
        XCTAssertFalse(folderManager.folder(url, contains: url))
        XCTAssertFalse(folderManager.folder(url, contains: failURL))
        XCTAssertFalse(folderManager.folder(failURL, contains: url))
    }
}
