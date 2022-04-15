//
//  BookModel.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 03.04.2022.
//

import Foundation
import UIKit

struct Book {
    var identifier : String? = UUID().uuidString
    var ownerId : String?
    var bookImagesNamesDB : [String]?
    var bookImages: [Data]
    var bookName: String
    var bookAuthor: String
    var bookGenres: Genre
    var bookCondition: Int
    var bookDescription: String?
    var bookLanguage: String
}
