//
//  AuthorizationController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import UIKit
import PinLayout
import FirebaseAuth

class AuthorizationController : UIViewController {
    var presenter: AuthorizationPresenter
    
    // убрать
    let lableFontSize = 16
    let textFieldFontSize = 14
    
    let lableHeight = 28
    let textFieldHeight = 32
    
    let textFieldCornerRadius = 14
    //
    
    let scrollView = UIScrollView()
    
    let loginLabel = UILabel()
    let loginTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField() 
    
    let authButton = UIButton()
    let newRegLabel = UILabel()
    let regButton = UIButton()
    
    init(output: AuthorizationPresenter){
        self.presenter = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Авторизация"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        
        self.hideKeyboardWhenTappedAround()
        
        setView()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
                
        scrollView.pin
            .top(view.pin.safeArea.top)
            .width(view.frame.width)
            .bottom(view.pin.safeArea.bottom)
       
        loginLabel.pin
            .top(12)
            .horizontally(12)
            .height(CGFloat(lableHeight))
        
        loginTextField.pin
            .below(of: loginLabel).marginTop(2)
            .horizontally(12)
            .height(CGFloat(textFieldHeight))
        
        passwordLabel.pin
            .below(of: loginTextField).marginTop(10)
            .horizontally(12)
            .height(CGFloat(lableHeight))
        
        passwordTextField.pin
            .below(of: passwordLabel).marginTop(2)
            .horizontally(12)
            .height(CGFloat(textFieldHeight))
        
        authButton.pin
            .below(of: passwordTextField).marginTop(18)
            .horizontally(12)
            .height(46)
        
        newRegLabel.pin
            .below(of: authButton).marginTop(18)
            .left(12)
            .right(view.frame.width/2+12/2)
            .height(CGFloat(textFieldHeight))

        regButton.pin
            .below(of: authButton).marginTop(18)
            .left(view.frame.width/2+12/2)
            .right(12)
            .height(CGFloat(textFieldHeight))
    }
    
    func setView(){
        scrollView.contentSize = CGSize(width: view.frame.width, height: 446 /*+ 500*/) // need changes
        view.addSubview(scrollView)
        
        loginLabel.text = "Электронная почта"
        passwordLabel.text = "Пароль"
        [loginLabel, passwordLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: CGFloat(lableFontSize))
            scrollView.addSubview(label)
        }
        
        loginTextField.placeholder = "Адрес электронной почты"
        loginTextField.keyboardType = UIKeyboardType.emailAddress
        loginTextField.autocorrectionType = UITextAutocorrectionType.no
        loginTextField.autocapitalizationType = .none
        
        passwordTextField.placeholder = "Введите пароль"
        passwordTextField.isSecureTextEntry = true

        [loginTextField, passwordTextField].forEach { textField in
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftViewMode = .always
            textField.layer.cornerRadius = CGFloat(textFieldCornerRadius)
            textField.font = UIFont.systemFont(ofSize: CGFloat(textFieldFontSize))
            textField.backgroundColor = .systemGray6
            scrollView.addSubview(textField)
        }
        
        authButton.setTitle("Войти", for: .normal)
        authButton.layer.shadowColor = UIColor(named: "buttonColor")?.cgColor
        authButton.layer.shadowOpacity = 0.2
        authButton.layer.shadowRadius = 10
        authButton.layer.shadowOffset = CGSize.zero
        
        regButton.setTitle("Регистрация", for: .normal)
        regButton.layer.shadowColor = UIColor(named: "buttonColor")?.cgColor
        regButton.layer.shadowOpacity = 0.2
        regButton.layer.shadowRadius = 10
        regButton.layer.shadowOffset = CGSize.zero
        
        authButton.addTarget(self,
                             action: #selector(didTapAuthButton(_:)),
                             for: .touchUpInside)
        regButton.addTarget(self,
                            action: #selector(didTapRegButton(_:)),
                            for: .touchUpInside)
        
        [authButton, regButton].forEach() { button in
            button.layer.cornerRadius = 15
            button.backgroundColor = UIColor(named: "buttonColor")
            button.setTitleColor(UIColor.white, for: .normal)
            scrollView.addSubview(button)
        }
        
        newRegLabel.text = "Нет аккаунта?"
        newRegLabel.textAlignment = .center
        scrollView.addSubview(newRegLabel)
    }
}

extension AuthorizationController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AuthorizationController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AuthorizationController {
    func regTapped() {
        let regPresenter = RegistrationPresenter()
        let regViewController = RegistrationController(presenter: regPresenter)
        navigationController?.pushViewController(regViewController, animated: true)
    }
    
    @objc func didTapRegButton(_ sender: UIButton) {
        self.presenter.didTapRegButton()
    }
}

extension AuthorizationController {
    @objc
    private func didTapAuthButton(_ sender: UIButton) {
       
        guard let email = loginTextField.text,
              let password = passwordTextField.text
        else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                //перенаправление на главный экран с таббаром
                Coordinator.rootVC(vc: MainViewController() )
            }
            else {
                let alert = UIAlertController(title: "Ошибка", message: "Проверьте правильность \n введенных данных", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
