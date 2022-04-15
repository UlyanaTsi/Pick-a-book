//
//  ChatController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 10.04.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import Firebase

class ChatController : MessagesViewController {
    let presenter: ChatPresenter!
    
    var userProfile: Profile!
    private var docReference: DocumentReference?
    var messages: [Message] = []
    
    var user2UID: String
    var userId: String?
    
    init(output: ChatPresenter, userSecId: String){
        self.presenter = output
        self.user2UID = userSecId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setView()
        setPresenter()
        
        self.title = "Chat"
        
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        messageInputBar.inputTextView.tintColor = UIColor(named: "buttonColor")
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        messageInputBar.delegate = self
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userId = Auth.auth().currentUser?.uid
        self.presenter.observeUserProfile(userId: userId!)
    }
    
    func setView(){
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = "Чат"
    }
    
    func setPresenter(){
        presenter.setViewDelegate(delegate: self)
    }
}

extension ChatController: InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    private func save(_ message: Message) {
        //Preparing the data as per our firestore collection
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        //Writing it to the thread using the saved document reference we saved in load chat function
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        })
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: userId!, senderName: userProfile.name)
        
        insertNewMessage(message)
        save(message)
        
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
    }
    
    func currentSender() -> SenderType {
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == userProfile.id {
            ImageManager.shared.getImage(with: userProfile.photoName!, completion: { [weak self] (result) in
                switch result {
                case .success(let data):
                    avatarView.image = UIImage(data: data)
                case .failure(_):
                    print("case fail")
                }})
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        
        return .bubbleTail(corner, .curved)
    }
}

extension ChatController {
    func loadChat() {
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                if queryCount == 0 {
                    //                    self.createNewChat(user2UID: )
                }
                else if queryCount >= 1 {
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        
                        if (chat?.users.contains(self.user2UID )) == true {
                            self.docReference = doc.reference
                            doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                    if let error = error {
                                        print("Error: \(error)")
                                        return
                                    } else {
                                        self.messages.removeAll()
                                        
                                        for message in threadQuery!.documents {
                                            let msg = Message(dictionary: message.data())
                                            self.messages.append(msg!)
                                        }
                                        
                                        self.messagesCollectionView.reloadData()
                                        self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                                    }
                                })
                            return
                        }
                    }
//                    self.createNewChat(user2UID: use)
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    public func createNewChat(user2UID: Profile) {
        let users = [userProfile.id, user2UID.id]
        let data: [String: Any] = [
            "users":users
        ]
        
        let db = Firestore.firestore().collection("Chats")
        
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
            }
        }
    }
    
    func reloadUserProfile(userProfile: Profile) {
        self.userProfile = userProfile
    }
}
