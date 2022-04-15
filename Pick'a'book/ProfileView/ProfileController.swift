//
//  ProfileController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 04.04.2022.
//
import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class ProfileController :  UIViewController {
    func presentAlert(title: String, message: String) {}
    
    var output: ProfilePresenter
    var myProfile: Profile!
    
    let profileImageView = UIImageView()
    let profileName = UILabel()
    let profilePhoneNumber = UILabel()
    let profileAboutInfo = UILabel()
    let logOutButton = UIButton()
    var length : CGFloat = 10
    
    let favoriteGenre : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.translatesAutoresizingMaskIntoConstraints = true
        
        return label
    }()
    
    init(output: ProfilePresenter){
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Мой профиль"
        
        setView()
        setPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let id = Auth.auth().currentUser?.uid
        self.output.observeProfile(userId: id!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateLayout()
    }
    
    func setView(){
        profileImageView.image = UIImage(named: "default")
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.masksToBounds = true
        view.addSubview(profileImageView)
        
        profileName.text = "Попуг Олежа"
        profileName.textAlignment = .center
        view.addSubview(profileName)
        
        profilePhoneNumber.text = "+4 44 44"
        profilePhoneNumber.font = profilePhoneNumber.font.withSize(14)
        profilePhoneNumber.textAlignment = .center
        view.addSubview(profilePhoneNumber)
        
        favoriteGenre.text = "Фантастика"
        favoriteGenre.sizeToFit()
        length = favoriteGenre.frame.width
        favoriteGenre.textColor = .white
        view.addSubview(favoriteGenre)
        
        profileAboutInfo.text = "Немного информация о пользователе."
        profileAboutInfo.textAlignment = .natural
        view.addSubview(profileAboutInfo)
        
        logOutButton.setTitle("Выйти",
                                  for: .normal)
        logOutButton.setTitleColor(UIColor(named: "buttonColor"), for: .normal)
        logOutButton.addTarget(self,
                                   action: #selector(didTapLogoutButton(_:)),
                                   for: .touchUpInside)
        
        view.addSubview(logOutButton)
    }
    
    func setPresenter(){
        output.setViewDelegate(delegate: self)
    }
    
    func updateLayout() {
        
        profileImageView.pin
            .top(view.pin.safeArea.top + 12)
            .topCenter()
            .size(120) 
        
        profileName.pin
            .below(of: profileImageView).marginTop(10)
            .horizontally(15)
            .height(28)
        
        profilePhoneNumber.pin
            .below(of: profileName).marginTop(2)
            .horizontally(15)
            .height(28)
        
        favoriteGenre.pin
            .below(of: profilePhoneNumber).marginTop(2)
            .left(15)
            .width(length + 10)
            .height(30)
        
        profileAboutInfo.pin
            .below(of: favoriteGenre).marginTop(5)
            .left(15)
            .horizontally(15)
            .height(100)
        
        logOutButton.pin
            .bottom(view.pin.safeArea).marginBottom(12)
            .left(view.frame.width / 2 - 100)
            .width(200)
            .height(50)
    }
}

extension ProfileController {
    func reloadMyProfile(myProfile: Profile) {
        self.myProfile = myProfile
        
        profileImageView.image = myProfile.photo
        profileName.text = myProfile.name
        profilePhoneNumber.text = myProfile.phoneNumber
        
        favoriteGenre.text = myProfile.favoriteGenre
        if let index = Util.shared.genres.firstIndex(where: { $0.name == myProfile.favoriteGenre} ) {
            favoriteGenre.backgroundColor = Util.shared.genres[index].color
        }
        length = favoriteGenre.frame.width
        
        profileAboutInfo.numberOfLines = 0
        profileAboutInfo.text = myProfile.textInfo
        profileAboutInfo.sizeToFit()
        
        updateLayout()
    }
}

extension ProfileController {
    @objc private func didTapLogoutButton(_ sender: UIButton) {
        //разлогинься
        try? Auth.auth().signOut()
        //перенаправление на экран авторизации
        let authorizationPresenter = AuthorizationPresenter()
        let authorizationViewController = AuthorizationController(output: authorizationPresenter)
        authorizationPresenter.delegate = authorizationViewController
        Coordinator.rootVC(vc: UINavigationController(rootViewController: authorizationViewController))
    }
}
