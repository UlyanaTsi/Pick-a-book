//
//  ChatPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 10.04.2022.
//

import Foundation

protocol ChatPresenterProtocol: AnyObject {
    func observeUserProfile(userId: String)
}

final class ChatPresenter : ChatPresenterProtocol {
    weak var delegate : ChatController!
    
    public func setViewDelegate(delegate: ChatController){
        self.delegate = delegate
    }
    
    func observeUserProfile(userId: String) {
        UserManager.shared.output = self
        UserManager.shared.observeUser(userId: userId)
    }
}

extension ChatPresenter : UserManagerOutput {
    
    func didRecieve(_ user: Profile) {
        print("должно произойти")
        self.delegate?.reloadUserProfile(userProfile: user)
    }
    
    func didCreate(_ user: Profile) {}
    
    func didFail(with error: Error) {}
    
    func didDelete(_ book: Book) {}
}
