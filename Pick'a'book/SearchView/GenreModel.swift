//
//  GenreModel.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 03.04.2022.
//

import Foundation
import UIKit

struct Genre {
    var type: GenreType
    var name: String
    var color: UIColor
}

enum GenreType {
    case bestsellers
    case art
    case fantasy
    case psychology
    case detectives
    case fantastic
    case roman
    case business
    case classic
    case comic
    case hobbiesntravel
    case biography
    case poetry
    case scipop
    case health
    case kidslit
    case notSelected
}
