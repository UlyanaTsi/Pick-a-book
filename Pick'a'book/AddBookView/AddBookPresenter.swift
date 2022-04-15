//
//  AddBookPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation
import UIKit

protocol AddNewBookPresenterProtocol: AnyObject {
    var newBook: Book { get set }
    func didTapAddButton(bookImages: [Data?],
                         bookName: String,
                         bookNameColor: UIColor,
                         authorName: String,
                         authorNameColor : UIColor,
                         bookDescription: String,
                         bookDescriptionColor : UIColor,
                         bookLanguage: String,
                         bookLanguageColor: UIColor)
    func didTapConditionButton(_ addedCondition: Int)
    func didTapAddPhotoButton()
}


final class AddNewBookPresenter: AddNewBookPresenterProtocol {
    var newBook: Book
    var genres = Util.shared.genres
    
    init() {
        newBook = Book(bookImages: [],
                       bookName: "",
                       bookAuthor: "",
                       bookGenres: genres[0],
                       bookCondition: 0,
                       bookDescription: nil,
                       bookLanguage: "Русский")
    }
    
    weak var view : AddNewBookController?
    
    public func setViewDelegate(delegate: AddNewBookController) {
        self.view = delegate
    }
    
    func didTapAddButton(bookImages:[Data?],
                         bookName: String,
                         bookNameColor: UIColor,
                         authorName: String,
                         authorNameColor : UIColor,
                         bookDescription: String,
                         bookDescriptionColor : UIColor,
                         bookLanguage: String,
                         bookLanguageColor: UIColor) {
        
        
        if (bookImages[1] == nil || bookName == "" ||  authorName == ""
            ||  bookLanguage == "" || bookNameColor == .gray
            || authorNameColor == .gray  || self.newBook.bookCondition == 0
            || self.newBook.bookGenres.type == genres[0].type) {
            
            self.view?.requiredFieldAlert()
            
        } else {
            view?.presentLoadingAlert()
            
            if bookImages[2] == nil {
                self.newBook.bookImages = [bookImages[1]!]
            }
            else if bookImages[0] == nil {
                self.newBook.bookImages = [bookImages[2]!, bookImages[1]!]
            }
            else {
                self.newBook.bookImages = [bookImages[2]!, bookImages[1]! , bookImages[0]!]
            }
            
            self.newBook.bookName = bookName
            self.newBook.bookAuthor = authorName
            
            if bookDescription == "" || bookDescriptionColor == .gray{
                self.newBook.bookDescription = nil
            } else {
                self.newBook.bookDescription = bookDescription
            }
            self.newBook.bookLanguage = bookLanguage

            BookManager.shared.output = self
            BookManager.shared.create(book: newBook)
        }
    }
    
    func didTapConditionButton(_ addedCondition: Int) {
        newBook.bookCondition = addedCondition
        self.view?.changeCondition(addedCondition)
    }
    
    func didTapAddPhotoButton() {
        self.view?.openSavedPhotosAlbum()
    }
}

extension AddNewBookPresenter: BookManagerOutput {
    func didDelete(_ book: Book) {
        print("error didDelete in AddNewBookPresenter")
    }
    
    func didRecieve(_ books: [Book]) {
        print("error didRecive in AddNewBookPresenter")
    }
    
    func didCreate(_ book: Book) {
        self.view?.dismissLoadingAlert()
        self.view?.finishedAdding()
    }
    
    func didFail(with error: Error) {
        self.view?.dismissLoadingAlert()
        self.view?.finishedAdding()
    }
}
