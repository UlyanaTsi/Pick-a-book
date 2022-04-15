//
//  ChatModel.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 10.04.2022.
//

import Foundation
import MessageKit

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
