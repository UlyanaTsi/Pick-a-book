//
//  RegistrationPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation
import FirebaseAuth
import UIKit

protocol RegistrationPresenterProtocol: AnyObject {
    
    func setViewDelegate(delegate: RegistrationController)
    func didTapAddPhotoButton()
    func didSetFavoriteGenre(genre: Genre)
    
    var newUser: Profile { get set }
    func didTapRegButton(name: String,
                         photoName: String?,
                         photo: UIImage?,
                         phoneNumber: String?,
                         email: String?,
                         telegramLink: String?,
                         textInfo: String?)
}


final class RegistrationPresenter: RegistrationPresenterProtocol, UserManagerOutput {
    weak var delegate: RegistrationController?
    var newUser: Profile
    private var genre: String?
    
    func didRecieve(_ user: Profile) { }
    func didCreate(_ user: Profile) { }
    func didFail(with error: Error) { }
    
    public func setViewDelegate(delegate: RegistrationController) {
        self.delegate = delegate
    }
    
    func didTapAddPhotoButton() {
        self.delegate!.openSavedPhotosAlbum()
    }
    
    init() {
        newUser = Profile(  id: "",
                            name: "",
                            photoName: "",
                            photo: UIImage(named: "addPhotoImage"),
                            phoneNumber: "",
                            email: "",
                            telegramLink: nil,
                            textInfo: "",
                            favoriteGenre: ""  )
    }
    
    func didTapRegButton( name: String,
                          photoName: String?,
                          photo: UIImage?,
                          phoneNumber: String?,
                          email: String?,
                          telegramLink: String?,
                          textInfo: String? ) {
        
        guard let newUserId = Auth.auth().currentUser?.uid else { return }
        self.newUser.id = newUserId
        self.newUser.photo = photo!
        self.newUser.name = name
        self.newUser.phoneNumber = phoneNumber
        self.newUser.email = email!
        self.newUser.telegramLink = telegramLink
        self.newUser.textInfo = textInfo
        self.newUser.favoriteGenre = genre
        
        UserManager.shared.output = self
        UserManager.shared.create(user: newUser)
    }
    
    func didSetFavoriteGenre(genre: Genre) {
        self.genre = genre.name
    }
}
