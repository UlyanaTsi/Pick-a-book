//
//  BookPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation

protocol BookViewPresenterProtocol: AnyObject {
    var bookOwner: Profile { get set }
    func takeBookButtonAction(book: Book)
    func setViewDelegate(delegate: BookProfileController)
    func observeBookOwner(ownerId: String)
}

final class BookProfilePresenter: BookViewPresenterProtocol {
    var bookOwner: Profile = Profile.init(id: "", name: "", photoName: "", photo: nil, phoneNumber: nil, email: "", telegramLink: "", textInfo: "", favoriteGenre: "")

    weak var delegate : BookProfileController?
    
    public func setViewDelegate(delegate: BookProfileController) {
        self.delegate = delegate
    }
    
    func takeBookButtonAction(book: Book){
        delegate?.presentNextVC()
    }
    
    func observeBookOwner(ownerId: String) {
        UserManager.shared.output = self
        UserManager.shared.observeUser(userId: ownerId)
    }
}

extension BookProfilePresenter : UserManagerOutput {
    func didFail(with error: Error) {
    }
    
    func didRecieve(_ user: Profile) {
        self.delegate?.loadBookOwner(ownerProfile: user)
    }
    
    func didCreate(_ user: Profile) { }
}
