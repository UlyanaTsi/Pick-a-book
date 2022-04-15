//
//  ProfileModel.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 04.04.2022.
//
import Foundation
import UIKit

struct Profile {
    
    var id: String
    var name: String
    var photoName: String?
    var photo: UIImage?
    var phoneNumber: String?
    var email: String?
    var telegramLink: String?
    var textInfo: String?
    var favoriteGenre: String?
    
    init(id: String, name: String, photoName: String?, photo: UIImage?, phoneNumber: String?, email: String?, telegramLink: String?, textInfo: String?, favoriteGenre: String?) {
        
        self.id = id
        self.name = name
        self.photoName = photoName
        self.photo = UIImage(named: "default") 
        self.phoneNumber = phoneNumber
        self.email = email
        self.telegramLink = telegramLink
        self.textInfo = textInfo
        self.favoriteGenre = favoriteGenre
    }
}

