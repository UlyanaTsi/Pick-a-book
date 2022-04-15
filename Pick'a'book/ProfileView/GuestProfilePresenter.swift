//
//  GuestProfilePresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 14.04.2022.
//

import Foundation
import FirebaseFirestore

protocol GuestProfilePresenterProtocol: AnyObject {
    var currentBooks: [Book] { get set }
    var userProfile: Profile { get set }
    
    func observeBooks(userId: String)
    func observeUserProfile(userId: String)
    func didTapOpenBook(book: Book)
    func setViewDelegate(delegate: GuestProfileController)
}
 
final class UserProfilePresenter: GuestProfilePresenterProtocol {
    weak var view: GuestProfileController?
    private let database = Firestore.firestore()

    var currentBooks: [Book] = []
    
    public func setViewDelegate(delegate: GuestProfileController) {
        self.view = delegate
    }
    
    func observeBooks(userId: String) {
        DispatchQueue.global().async {
            BookManager.shared.output = self
            BookManager.shared.observeOwnerIdBooks(id: userId)
        }
    }
    
    var userProfile: Profile = Profile.init(id: "", name: "", photoName: "", photo: nil, phoneNumber: nil, email: "", telegramLink: "", textInfo: "", favoriteGenre: "")
    
    func observeUserProfile(userId: String) {
        UserManager.shared.output = self
        UserManager.shared.observeUser(userId: userId)
    }
        
    func didTapOpenBook(book: Book) {
        self.view?.openBook(book:  book)
    }
}


extension UserProfilePresenter : BookManagerOutput {
    func didRecieve(_ books: [Book]) {
        currentBooks = books.sorted(by: { $0.bookName < $1.bookName })
        self.view?.reloadTable()
    }
    
    func didCreate(_ book: Book) {
        print("error didCreate in MyProfilePresenter")
    }
    
    func didFail(with error: Error) {
        print("error didFail in MyProfilePresenter")
    }
    
    func didDelete(_ book: Book) {
        print("error didDelete in MyProfilePresenter")
    }
    
    
}

extension UserProfilePresenter : UserManagerOutput {
    
    func didRecieve(_ user: Profile) {
        print ("didRecieve IN WORK")
        print (user)
        self.view?.reloadUserProfile(userProfile: user)
    }
    
    func didCreate(_ user: Profile) { }
}


