//
//  ChatPresenter.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 09.04.2022.
//

import Foundation

protocol MessengerPresenterProtocol: AnyObject {
    
}

final class MessengerPresenter : MessengerPresenterProtocol {
    weak var delegate : MessengerController?
    
    public func setViewDelegate(delegate: MessengerController){
        self.delegate = delegate
    }
}
