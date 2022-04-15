//
//  QuestProfile.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 12.04.2022.
//

import UIKit
import Firebase
import PinLayout

class GuestProfileController : UIViewController {
    
    func presentAlert(title: String, message: String) {}
    
    var output: UserProfilePresenter
    var userProfile: Profile!
    var telegramUrl: URL?
    var userId: String
    var length : CGFloat = 10
    
    let profileImageView = UIImageView()
    let profileName = UILabel()
    let profileMailAdress = UILabel()
    let profilePhoneNumber = UILabel()
    let profileBookListTitle = UILabel()
    let profileAboutInfo = UILabel()
    let profileBookListTableView = UITableView()
    let linksView = UIView()
    var profileTelegramLinkIcon = UIImage(named: "telegramIcon")
    let profileTelegramLinkImageView = UIImageView()
    
    let favoriteGenre : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.translatesAutoresizingMaskIntoConstraints = true
        
        return label
    }()
    
    init(output: UserProfilePresenter, userId: String){
        self.output = output
        self.userId = userId
        self.telegramUrl = URL(string: "")
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.setViewDelegate(delegate: self)
        
        view.backgroundColor = .white
        navigationItem.title = "Профиль пользователя"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        
        //фото профиля
        profileImageView.image = UIImage(named: "default")
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.masksToBounds = true
        view.addSubview(profileImageView)
        
        //имя в профиле
        profileName.text = "Попуг Геночка"
        profileName.textAlignment = .center
        view.addSubview(profileName)
        
        // описание
        profileAboutInfo.text = "Кулинарные книги не предлагать"
        profileAboutInfo.textAlignment = .natural
        profileAboutInfo.numberOfLines = 0
        profileAboutInfo.sizeToFit()
        view.addSubview(profileAboutInfo)
        
        // жанр
        favoriteGenre.text = "Фантастика"
        favoriteGenre.sizeToFit()
        length = favoriteGenre.frame.width
        favoriteGenre.textColor = .white
        view.addSubview(favoriteGenre)
        
        // почта
        profileMailAdress.text = "peekabook@peeka.book"
        profileMailAdress.font = profileMailAdress.font.withSize(14)
        profileMailAdress.textAlignment = .center
        view.addSubview(profileMailAdress)
        
        // телефон
        profilePhoneNumber.text = "+5 55 55"
        profilePhoneNumber.font = profilePhoneNumber.font.withSize(14)
        profilePhoneNumber.textAlignment = .center
        view.addSubview(profilePhoneNumber)
        
        // заголовок
        profileBookListTitle.text = "Книги на обмен"
        view.addSubview(profileBookListTitle)
        
        // таблица с ячейками книг
        profileBookListTableView.dataSource = self
        profileBookListTableView.delegate = self
        profileBookListTableView.register(BookTableCell.self, forCellReuseIdentifier: "BookTableCell")
        view.addSubview(profileBookListTableView)
        
        // блок ссылок
        view.addSubview(linksView)
        profileTelegramLinkImageView.image = profileTelegramLinkIcon
        linksView.addSubview(profileTelegramLinkImageView)
        
        // распознание нажатий
        let telegramTapGesture = UITapGestureRecognizer(target: self, action: #selector(GuestProfileController.telegramImageTapped(gesture: )))
        profileTelegramLinkImageView.addGestureRecognizer(telegramTapGesture)
        profileTelegramLinkImageView.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output.observeBooks(userId: userId)
        self.output.observeUserProfile(userId: userId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //updateLayout()
    }
    
    func updateLayout() {
        
        profileImageView.pin
            .top(view.pin.safeArea.top+12)
            .topCenter()
            .size(120)
        
        profileName.pin
            .below(of: profileImageView).marginTop(10)
            .horizontally(12)
            .height(28)
        
        profileMailAdress.pin
            .below(of: profileName).marginTop(-4)
            .horizontally(12)
            .height(28)
        
        profilePhoneNumber.pin
            .below(of: profileMailAdress).marginTop(-10)
            .horizontally(12)
            .height(28)
        
        linksView.pin
            .below(of: profilePhoneNumber).marginTop(10)
            .topCenter()
            .width(100)
            .height(36)
        
        profileTelegramLinkImageView.pin
            .topCenter(0)
            .size(linksView.frame.height)
        
        favoriteGenre.pin
            .below(of: linksView).marginTop(4)
            .left(12)
            .width(length + 10)
            .height(30)
        
        profileAboutInfo.pin
            .below(of: favoriteGenre).marginTop(0)
            .horizontally(12)
            .height(80)
        
        profileBookListTitle.pin
            .below(of: profileAboutInfo).marginTop(4)
            .horizontally(12)
            .height(28)
        
        profileBookListTableView.pin
            .below(of: profileBookListTitle).marginTop(4)
            .horizontally(5)
            .bottom(12)
    }
}

extension GuestProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.output.currentBooks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as? BookTableCell else {
            return .init()
        }
        
        let book = self.output.currentBooks[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = self.output.currentBooks[indexPath.row]
        output.didTapOpenBook(book: book)
    }
}

extension GuestProfileController {
    
    func reloadUserProfile(userProfile: Profile) {
        self.userProfile = userProfile
        
        profileImageView.image = userProfile.photo
        profileName.text = userProfile.name
        profileMailAdress.text = userProfile.email
        profilePhoneNumber.text = userProfile.phoneNumber
        profileAboutInfo.text = userProfile.textInfo
        
        let telLink = userProfile.telegramLink ?? ""
        
        telegramUrl = URL(string: telLink)
        
        if telegramUrl == nil {
            profileTelegramLinkIcon = UIImage(named: "telegramInactIcon")
            profileTelegramLinkImageView.image = profileTelegramLinkIcon
        }
        
        favoriteGenre.text = userProfile.favoriteGenre
        if let index = Util.shared.genres.firstIndex(where: { $0.name == userProfile.favoriteGenre} ) {
            favoriteGenre.backgroundColor = Util.shared.genres[index].color
        }
        length = favoriteGenre.frame.width
        
        updateLayout()
    }
    
    func reloadTable() {
        self.profileBookListTableView.reloadData()
    }
    
    func openBook(book: Book) {
        let bookViewPresenter = BookProfilePresenter()
        let bookProfileViewController = BookProfileController(output: bookViewPresenter, book: book, owned: true)
        navigationController?.pushViewController(bookProfileViewController, animated: true)
    }
    
}

extension GuestProfileController {
    @objc func telegramImageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            
            if telegramUrl == nil {
                let alert = UIAlertController(title: "Нет информации",
                                              message: "Пользователь не указал \n ник в Telegram",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок",
                                              style: .default,
                                              handler: nil))
                present(alert, animated: true)
            }
            else { UIApplication.shared.open(telegramUrl!) }
        }
    }
}

