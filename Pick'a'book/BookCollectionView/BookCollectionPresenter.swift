//
//  BookCollectionPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 03.04.2022.
//

import Foundation
import UIKit

protocol BooksCollectionPresenterProtocol: AnyObject {
    func chosedBook(book: Book)
    var currentBooks : [Book] { get set }
    func observeBooks(genre: Genre)
}

final class BooksCollectionPresenter: BooksCollectionPresenterProtocol {
    weak var delegate : BooksCollectionController?
    var currentBooks : [Book] = []
    
    public func setViewDelegate(delegate: BooksCollectionController) {
        self.delegate = delegate
    }
    
    func observeBooks(genre: Genre) {
        BookManager.shared.output = self
        BookManager.shared.observeGenreBooks(genreName: genre.name)
    }
    
    func chosedBook(book: Book) {
        // открывает страницу книги
        delegate?.presentNextVC(selectedBook: book)
    }
}

extension BooksCollectionPresenter : BookManagerOutput {
    func didDelete(_ book: Book) {
        print("error")
    }
    
    func didRecieve(_ books: [Book]) {
        currentBooks = books.sorted(by: { $0.bookName < $1.bookName })
        self.delegate?.reloadCollection()
    }
    
    func didCreate(_ book: Book) {
        print("plohoCreate")
    }
    
    func didFail(with error: Error) {
        print("plohoFail")
    }
}
