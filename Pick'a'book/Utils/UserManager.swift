//
//  UserManager.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation
import FirebaseFirestore
import UIKit

protocol UserManagerProtocol {
    var output: UserManagerOutput? { get set }
    func observeUser(userId : String)
    func create(user: Profile)
}

protocol UserManagerOutput : AnyObject {
    func didRecieve(_ user: Profile)
    func didCreate(_ user: Profile)
    func didFail(with error: Error)
}

final class UserManager : UserManagerProtocol {
    
    static var shared: UserManagerProtocol = UserManager()
    weak var output: UserManagerOutput?
    
    private var user: Profile = Profile(id: "", name: "", photoName: "", photo: nil, phoneNumber: nil, email: "", telegramLink: "", textInfo: "", favoriteGenre: "")
    
    private let database = Firestore.firestore()
    private let userConverter = ProfileDataConverter()
    
    func create(user: Profile) {
        guard let data = user.photo?.jpegData(compressionQuality: 0.1) else { return }
        
        ImageManager.shared.uploadImage(imageData: [data]) { [weak self] imageURLs, imageNames in
            //if user.userImages.count == imageURLs.count {
            
            var dictForDatabase : [String : Any]
            dictForDatabase = ["id" : user.id,
                               "name" : user.name,
                               "phoneNumber" : user.phoneNumber ?? "",
                               "email" : user.email ?? "",
                               "telegramLink" : user.telegramLink ?? "",
                               "textInfo" : user.textInfo ?? "",
                               "photoName" : imageNames,
                               "photoURL" : imageURLs,
                               "favoriteGenre" : user.favoriteGenre ?? "Не выбран"]
            
            self?.database.collection("Users").addDocument(data: dictForDatabase) { [weak self] error in
                if let error = error {
                    print("Error writing document: \(error)")
                    self?.output?.didFail(with: error)
                }
                else {
                    print("Document successfully written!")
                    self?.output?.didCreate(user)
                }
            }
        }
    }
    
    func observeUser(userId : String){
        self.database.collection("Users").whereField("id", isEqualTo: userId).addSnapshotListener { [weak self] querySnapshot, error in
            
            if let error = error {
                print ("Ошибка при получении юзера" + error.localizedDescription)
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkError.unexpected)
                return
            }
            
            var user = (self?.userConverter.profileData(from: documents[0]))!
            
            let defaultProfile : Profile = Profile.init(id: "", name: "", photoName: "", photo: nil, phoneNumber: nil, email: "", telegramLink: "", textInfo: "", favoriteGenre: "")
            
            self?.output?.didRecieve(user)
            self?.user = user
            
            guard let name = user.photoName else {
                return
            }
            
            ImageManager.shared.getImage(with: name) { [weak self] (result) in
                switch result {
                case .success(let data):
                    user.photo = UIImage(data: data)
                    self?.output?.didRecieve(user)
                case .failure(_):
                    print("case fail")
                }
            }
        }
    }
}

private final class ProfileDataConverter {
    
    enum Key: String {
        case email
        case id
        case textInfo
        case name
        case phoneNumber
        case photoName
        case photoURL
        case telegramLink
        case favoriteGenre
    }
    
    func profileData (from document: DocumentSnapshot) -> Profile? {
        guard let dict = document.data(),
              let id = dict[Key.id.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String,
              let email = dict[Key.email.rawValue] as? String,
              let phoneNumber = dict[Key.phoneNumber.rawValue] as? String,
              let photoName = dict[Key.photoName.rawValue] as? [String],
              let textInfo = dict[Key.textInfo.rawValue] as? String,
              let favoriteGenre = dict[Key.favoriteGenre.rawValue] as? String
        else {
            return nil
        }
        
        var telegramLink = dict[Key.telegramLink.rawValue] as? String
        if dict[Key.telegramLink.rawValue] == nil { telegramLink = "" }
        
        let profileDataResult = Profile(id: id, name: name, photoName: photoName[0], photo: nil, phoneNumber: String(phoneNumber), email: email, telegramLink: telegramLink, textInfo: textInfo, favoriteGenre: favoriteGenre)
        return profileDataResult
    }
}
