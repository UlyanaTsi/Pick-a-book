//
//  GenreCollectionView.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 03.04.2022.
//

import UIKit

protocol SearchPresenterProtocol: AnyObject {
    func chosedGenre(genre: Genre)
}

final class SearchPresenter: SearchPresenterProtocol {
    weak var delegate : SearchController?
    
    public func setViewDelegate(delegate: SearchController) {
        self.delegate = delegate
    }
    
    func chosedGenre(genre: Genre) {
        delegate?.presentNextVC(genre: genre)
    }
}
