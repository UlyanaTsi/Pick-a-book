//
//  RegistrationController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import UIKit
import PinLayout
import FirebaseAuth
import FirebaseFirestore

class RegistrationController : UIViewController {
    
    var presenter: RegistrationPresenter!
    
    let scrollView = UIScrollView()
    
    // image
    let profileImageView = UIImageView()
    let addPhotoButton = UIButton()
    let correctPhotoButton = UIButton()
    var addPhotoImagePicker = UIImagePickerController()
    
    // email
    let emailAdressLabel = UILabel()
    let emailAdressTextField = UITextField()
    
    // password
    let newPasswordFirstLabel = UILabel()
    let newPasswordFirstTextField = UITextField()
    let newPasswordSecondLabel = UILabel()
    let newPasswordSecondTextField = UITextField()
    
    //other
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    
    let phoneNumberLabel = UILabel()
    let phoneNumberTextField = UITextField()
    
    let telegramLinkLabel = UILabel()
    let telegramLinkTextField = UITextField()
    
    let textInfoLabel = UILabel()
    let textInfoTextField = UITextField()
    
    let favGenreLabel = UILabel()
    let favGenrePickerView = UIPickerView()
    
    let generalRegLabel = UILabel()
    let generalLinksLabel = UILabel()
    let generalAboutLabel = UILabel()
    
    let endRegistrationButton = UIButton()
    
    init(presenter: RegistrationPresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Регистрация"
        self.hideKeyboardWhenTappedAround()
        
        setView()
        setPresenter()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        scrollView.pin
            .topLeft()
            .height(view.frame.height)
            .width(view.frame.width)
        
        addPhotoButton.pin
            .top(10)
            .topCenter()
            .height(120)
            .width(120)
        
        nameLabel.pin
            .below(of: addPhotoButton).marginTop(10)
            .horizontally(12)
            .height(28)
        
        nameTextField.pin
            .below(of: nameLabel).marginTop(2)
            .horizontally(12)
            .height(38)
        
        generalRegLabel.pin
            .below(of: nameTextField).marginTop(14)
            .horizontally(12)
            .height(CGFloat(28))
        
        emailAdressLabel.pin
            .below(of: generalRegLabel).marginTop(2)
            .horizontally(12)
            .height(28)
        
        emailAdressTextField.pin
            .below(of: emailAdressLabel).marginTop(2)
            .horizontally(12)
            .height(38)
        
        newPasswordFirstLabel.pin
            .below(of: emailAdressTextField).marginTop(10)
            .horizontally(12)
            .height(28)
        
        newPasswordFirstTextField.pin
            .below(of: newPasswordFirstLabel).marginTop(2)
            .horizontally(12)
            .height(38)
        
        newPasswordSecondLabel.pin
            .below(of: newPasswordFirstTextField).marginTop(10)
            .horizontally(12)
            .height(28)
        
        newPasswordSecondTextField.pin
            .below(of: newPasswordSecondLabel).marginTop(2)
            .horizontally(12)
            .height(38)
        
        generalLinksLabel.pin
            .below(of: newPasswordSecondTextField).marginTop(14)
            .horizontally(12)
            .height(28)
        
        phoneNumberLabel.pin
            .below(of: generalLinksLabel).marginTop(2)
            .horizontally(12)
            .height(28)
        
        phoneNumberTextField.pin
            .below(of: phoneNumberLabel).marginTop(2)
            .horizontally(12)
            .height(38)
        
        telegramLinkLabel.pin
            .below(of: phoneNumberTextField).marginTop(10)
            .horizontally(12)
            .height(28)
        
        telegramLinkTextField.pin
            .below(of: telegramLinkLabel).marginTop(2)
            .horizontally(12)
            .height(38)
        
        generalAboutLabel.pin
            .below(of: telegramLinkTextField).marginTop(14)
            .horizontally(12)
            .height(28)
        
        textInfoLabel.pin
            .below(of: generalAboutLabel).marginTop(2)
            .horizontally(12)
            .height(28)
        
        textInfoTextField.pin
            .below(of: textInfoLabel).marginTop(2)
            .horizontally(12)
            .height(88)
        
        favGenreLabel.pin
            .below(of: textInfoTextField).marginTop(10)
            .horizontally(12)
            .height(28)
        
        favGenrePickerView.pin
            .below(of: favGenreLabel).marginTop(2)
            .horizontally(12)
            .height(120)
        
        endRegistrationButton.pin
            .bottom(view.pin.safeArea).marginBottom(10)
            .left(view.frame.width / 2 - 100)
            .width(200)
            .height(50)
    }
    
    func setView(){
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1100)
        view.addSubview(scrollView)
        
        addPhotoImagePicker.delegate = self
        setImagePicker()
        
        emailAdressLabel.text = "Электронная почта"
        newPasswordFirstLabel.text = "Придумайте пароль"
        newPasswordSecondLabel.text = "Повторите пароль"
        nameLabel.text = "Имя"
        phoneNumberLabel.text = "Номер телефона"
        telegramLinkLabel.text = "Ваш ник в Telegram"
        textInfoLabel.text = "Расскажите о своих любимых авторах и книгах"
        favGenreLabel.text = "Выберите свой любимый жанр"
        
        [emailAdressLabel, newPasswordFirstLabel, newPasswordSecondLabel, nameLabel, phoneNumberLabel, telegramLinkLabel, textInfoLabel, favGenreLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16)
            scrollView.addSubview(label)
        }
        
        nameTextField.placeholder = "Введите имя"
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        
        emailAdressTextField.placeholder = "Адрес электронной почты"
        emailAdressTextField.autocorrectionType = UITextAutocorrectionType.no
        emailAdressTextField.keyboardType = UIKeyboardType.emailAddress
        emailAdressTextField.autocapitalizationType = .none
        
        newPasswordFirstTextField.placeholder = "Придумайте пароль"
        newPasswordFirstTextField.isSecureTextEntry = true
        
        newPasswordSecondTextField.placeholder = "Повторите пароль"
        newPasswordSecondTextField.isSecureTextEntry = true
        
        phoneNumberTextField.placeholder = "Введите телефон"
        phoneNumberTextField.keyboardType = UIKeyboardType.phonePad
        phoneNumberTextField.delegate = self
        
        telegramLinkTextField.placeholder = "Ваш ник в Telegram"
        telegramLinkTextField.autocorrectionType = UITextAutocorrectionType.no
        telegramLinkTextField.autocapitalizationType = .none
        
        textInfoTextField.placeholder = "Расскажите о своих любимых авторах и книгах"
        textInfoTextField.autocorrectionType = UITextAutocorrectionType.no
        textInfoTextField.sizeToFit()
        textInfoTextField.autocapitalizationType = .none
        
        favGenrePickerView.delegate = self
        favGenrePickerView.dataSource = self
        favGenrePickerView.tintColor = UIColor(named: "buttonColor")
        scrollView.addSubview(favGenrePickerView)
        
        [emailAdressTextField, newPasswordFirstTextField, newPasswordSecondTextField, nameTextField, phoneNumberTextField, telegramLinkTextField, textInfoTextField].forEach { textField in
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftViewMode = .always
            textField.layer.cornerRadius = 15
            textField.font = UIFont.systemFont(ofSize: 14)
            textField.backgroundColor = .systemGray6
            scrollView.addSubview(textField)
        }
        
        generalRegLabel.text = "Данные для регистрации"
        generalAboutLabel.text = "Информация о пользователе"
        generalLinksLabel.text = "Способы связи"
        [generalRegLabel, generalAboutLabel, generalLinksLabel].forEach() { label in
            label.font = label.font.withSize(18)
            label.textAlignment = .center
            scrollView.addSubview(label)
        }
        
        endRegistrationButton.layer.cornerRadius = 20
        endRegistrationButton.layer.shadowColor = UIColor(named: "buttonColor")?.cgColor
        endRegistrationButton.layer.shadowOpacity = 0.2
        endRegistrationButton.layer.shadowRadius = 10
        endRegistrationButton.layer.shadowOffset = CGSize.zero
        endRegistrationButton.backgroundColor = UIColor(named: "buttonColor")
        endRegistrationButton.setTitle("Cохранить", for: .normal)
        endRegistrationButton.tintColor = .white
        endRegistrationButton.addTarget(self,
                                        action: #selector(didTapSaveButton(_:)),
                                        for: .touchUpInside)
        
        view.addSubview(endRegistrationButton)
        
        setPresenter()
    }
    
    func setImagePicker(){
        addPhotoButton.backgroundColor = UIColor(named: "backgroundColorForEmpty")
        addPhotoButton.layer.cornerRadius = 60
        addPhotoButton.setImage(UIImage(named: "addPhotoImage"), for: .normal)
        addPhotoButton.addTarget(self,
                                 action: #selector(didTapAddPhotoButton(_:)),
                                 for: .touchUpInside)
        scrollView.addSubview(addPhotoButton)
        profileImageView.isHidden = true
    }
    
    func setPresenter(){
        presenter.setViewDelegate(delegate: self)
    }
}

extension RegistrationController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//только цифры в номере телефона
extension RegistrationController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension RegistrationController {
    @objc
    private func didTapSaveButton(_ sender: UIButton) {
        
        guard let email = emailAdressTextField.text,
              let password = newPasswordFirstTextField.text,
              let secPassword = newPasswordSecondTextField.text
        else { return }
        
        var telegramLink = "https://t.me/"
        if telegramLinkTextField.text != "" {
            telegramLink += telegramLinkTextField.text!
            telegramLink = telegramLink.replacingOccurrences(of: " ", with: "")
        } else { telegramLink = "" }
        
        var profileImage = profileImageView.image
        if profileImage == nil { profileImage = UIImage(named: "default") }
        
        func RegAlert (regAlert: String) {
            let alert = UIAlertController(title: "Ошибка", message: regAlert, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        //проверка корректности введенных данных
        if nameTextField.text == "" {
            RegAlert (regAlert:  "Введите имя пользователя")
        }
        else if emailAdressTextField.text == "" || newPasswordFirstTextField.text == "" || newPasswordSecondTextField.text == "" {
            RegAlert (regAlert:  "Введите почту и/или пароль")
        }
        else if password != secPassword {
            RegAlert (regAlert:  "Пароли не совпадают")
        }
        else if textInfoTextField.text == "" {
            RegAlert (regAlert:  "Необходимо ввести описание")
        }
        else if phoneNumberTextField.text == "" && telegramLinkTextField.text == "" {
            RegAlert (regAlert:  "Необходимо ввести номер телефона или телеграм")
        }
        else {
            Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
                if error == nil { //если нет ошибок
                    //запись в базу данных
                    self.presenter.didTapRegButton( name: nameTextField.text!,
                                                    photoName: nil,
                                                    photo: profileImage,
                                                    phoneNumber: phoneNumberTextField.text,
                                                    email: emailAdressTextField.text,
                                                    telegramLink: telegramLinkTextField.text,
                                                    textInfo: textInfoTextField.text)
                    //перенаправление на главный экран с таббаром
                    Coordinator.rootVC( vc: MainViewController() )
                } else {
                    RegAlert (regAlert:  "Проверьте наличие интернет-подключения")
                }
            }
        }
    }
    
    @objc
    private func didTapAddPhotoButton(_ sender: UIButton) {
        self.presenter.didTapAddPhotoButton()
    }
    
    @objc
    private func didTapCorrectPhotoButton(_ sender: UIButton) {
        
        if profileImageView.image != nil {
            addPhotoButton.isHidden = false
        }
        
        if profileImageView.image != nil {
            profileImageView.image = nil
            profileImageView.isHidden = true
            
            correctPhotoButton.isHidden = true
        }
    }
    
    func openSavedPhotosAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            addPhotoImagePicker.allowsEditing = false
            addPhotoImagePicker.sourceType = .savedPhotosAlbum
            
            present(addPhotoImagePicker,
                    animated: true,
                    completion: nil)
        } else {
            let alert = UIAlertController(title: "Нет доступа!",
                                          message: "У Pickabook нет доступа к вашим фото.\nЧтобы предоставить доступ, перейдите в Настройки и включите Фото.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок",
                                          style: .default,
                                          handler: nil))
            
            present(alert, animated: true)
        }
    }
    
    func setImage(_ pickedImage: UIImage) {
        addPhotoButton.contentMode = .scaleToFill
        addPhotoButton.setImage(pickedImage, for: .normal)
        
        addPhotoButton.layer.cornerRadius = 60
        addPhotoButton.layer.masksToBounds = true
        
        // сохраняем для того, чтобы сохранять в бд
        profileImageView.image = pickedImage
        
        correctPhotoButton.isHidden = false
    }
}

extension RegistrationController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            setImage(pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// for genre picker
extension RegistrationController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Util.shared.genres.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Util.shared.genres[row].name
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.didSetFavoriteGenre(genre: Util.shared.genres[row])
    }
}
