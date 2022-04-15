//
//  LibraryPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation
import FirebaseAuth

protocol LibraryPresenterProtocol : AnyObject {
    var currentBooks : [Book] { get set }
    func dismissView()
    func didTapOpenAddNewBook()
    func didTapOpenBook(book: Book)
    func observeBooks()
    func deleteBook(book: Book, index: Int)
}

final class LibraryPresenter : LibraryPresenterProtocol {
    
    weak var delegate : LibraryController?
    
    var currentBooks : [Book] = []
    private var deletedBook : Book? = nil
    
    public func setViewDelegate(delegate: LibraryController) {
        self.delegate = delegate
    }
    
    func didTapOpenBook(book: Book) {
        self.delegate?.didTapOpenBook(book: book)
    }
    
    func dismissView() {
        self.delegate?.dismissView()
    }
    
    
    func didTapOpenAddNewBook() {
        print("opened AddNewBook")
        self.delegate?.didTapOpenAddNewBook()
        
    }
    
    func observeBooks() {
        DispatchQueue.global().async {
            BookManager.shared.output = self
            guard let MyId = Auth.auth().currentUser?.uid else {
                print("didn't registere")
                return}
            BookManager.shared.observeOwnerIdBooks(id: MyId)
        }
    }
    
    func deleteBook(book: Book, index: Int) {
        self.currentBooks.remove(at: index)
        self.deletedBook = book
        BookManager.shared.output = self
        BookManager.shared.delete(book: book)
    }
}


extension LibraryPresenter : BookManagerOutput {
    func didDelete(_ book: Book) {
        self.delegate?.successDeleteAlert()
    }
    
    func didRecieve(_ books: [Book]) {
        print("didRecieve in LibraryPresenter")
        currentBooks = books.sorted(by: { $0.bookName < $1.bookName })
        self.delegate?.reloadTable()
    }
    
    func didCreate(_ book: Book) {
        print("error didCreate in LibraryPresenter")
    }
    
    func didFail(with error: Error) {
        guard let deletedBook = self.deletedBook else {
            return
        }
        self.currentBooks.append(deletedBook)
        self.deletedBook = nil
        self.currentBooks.sort { $0.bookName < $1.bookName }
        self.delegate?.reloadTable()
        self.delegate?.errorAlert()
    }
}
