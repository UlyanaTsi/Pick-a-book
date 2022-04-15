//
//  ProfilePresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 04.04.2022.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol ProfilePresenterProtocol: AnyObject {
    var myProfile: Profile { get set }
    
    func observeProfile(userId: String)
    func observeUserProfile(userId: String)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileController!
    
    private let database = Firestore.firestore()
    
    public func setViewDelegate(delegate: ProfileController) {
        self.view = delegate
    }
    
    var myProfile: Profile = Profile.init(id: "", name: "", photoName: "", photo: nil, phoneNumber: "", email: "", telegramLink: "", textInfo: "", favoriteGenre: "")
    
    func observeProfile(userId: String) {
        UserManager.shared.output = self
        guard let id = Auth.auth().currentUser?.uid else { return }
        UserManager.shared.observeUser(userId: id)
    }
    
    func observeUserProfile(userId: String) {
        UserManager.shared.output = self
        UserManager.shared.observeUser(userId: userId)
    }
}

extension ProfilePresenter : UserManagerOutput {
    
    func didRecieve(_ user: Profile) {
        self.view?.reloadMyProfile(myProfile: user)
    }
    
    func didCreate(_ user: Profile) { }
    
    func didFail(with error: Error) {
        print("error didFail in MyProfilePresenter")
    }
    
    func didDelete(_ book: Book) {
        print("error didDelete in MyProfilePresenter")
    }
}
