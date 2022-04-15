//
//  AuthorizationPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation

protocol AuthorizationPresenterProtocol: AnyObject {
    func didTapRegButton()
}
 
final class AuthorizationPresenter: AuthorizationPresenterProtocol {
    weak var delegate: AuthorizationController?
    
    func didTapRegButton() {
        self.delegate?.regTapped()
    }
}
