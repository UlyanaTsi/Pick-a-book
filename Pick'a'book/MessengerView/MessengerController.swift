//
//  ChatController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 09.04.2022.
//

import UIKit
import MessageKit

class MessengerController : UIViewController {
    let presenter: MessengerPresenter!
    
    init(output: MessengerPresenter){
        self.presenter = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setView()
        
        super.viewDidLoad()
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
