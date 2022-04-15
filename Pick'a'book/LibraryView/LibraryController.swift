//
//  LibraryController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 06.04.2022.
//

import Foundation
import UIKit
import PinLayout

class LibraryController : UIViewController {
    
    var presenter: LibraryPresenter!
    
    let addNewBookButton = UIButton()
    let booksTableView = UITableView()
    
    init(presenter: LibraryPresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setPresenter()
    }
    
    func setView(){
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = "Книги на обмен"
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        
        swipeDownGestureRecognizer.direction = .down
        swipeUpGestureRecognizer.direction = .up
        
        swipeDownGestureRecognizer.delegate = self
        swipeUpGestureRecognizer.delegate = self
        
        booksTableView.isUserInteractionEnabled = true
        
        booksTableView.addGestureRecognizer(swipeDownGestureRecognizer)
        booksTableView.addGestureRecognizer(swipeUpGestureRecognizer)
        
        booksTableView.dataSource = self
        booksTableView.delegate = self
        booksTableView.register(BookTableCell.self, forCellReuseIdentifier: "BookTableCell")
        booksTableView.separatorStyle = .none
        view.addSubview(booksTableView)
        
        addNewBookButton.setTitle("Добавить книгу",
                                  for: .normal)
        addNewBookButton.setTitleColor(.white, for: .normal)
        addNewBookButton.layer.cornerRadius = 20
        addNewBookButton.layer.shadowColor = UIColor(named: "buttonColor")?.cgColor
        addNewBookButton.layer.shadowOpacity = 0.2
        addNewBookButton.layer.shadowRadius = 10
        addNewBookButton.layer.shadowOffset = .zero
        addNewBookButton.addTarget(self,
                                   action: #selector(didTapAddNewBookButton(_:)),
                                   for: .touchUpInside)
        addNewBookButton.backgroundColor = UIColor(named: "buttonColor")
        
        view.addSubview(addNewBookButton)
    }
    
    func setPresenter(){
        presenter.setViewDelegate(delegate: self)
    }
    
    @objc
    private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            if sender.direction == .up {
                addNewBookButton.isHidden = true
            } else if sender.direction == .down {
                addNewBookButton.isHidden = false
            }
        default:
            break
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.observeBooks()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        booksTableView.pin
            .top(view.pin.safeArea).marginTop(12)
            .horizontally(12)
            .bottom(view.pin.safeArea)
        
        addNewBookButton.pin
            .bottom(view.pin.safeArea).marginBottom(12)
            .left(view.frame.width / 2 - 100)
            .width(200)
            .height(50)
    }
    
    @objc
    private func didTapAddNewBookButton(_ sender: UIButton) {
        presenter.didTapOpenAddNewBook()
    }
    
}

extension LibraryController {
    
    func dismissView() {
        dismiss(animated: true,
                completion: nil)
    }
    
    func didTapOpenBook(book: Book) {
        let bookViewPresenter = BookProfilePresenter()
        let bookProfileViewController = BookProfileController(output: bookViewPresenter, book: book, owned: true)
        navigationController?.pushViewController(bookProfileViewController, animated: true)
        navigationController?.navigationBar.tintColor = .black
    }
    
    func reloadTable() {
        self.booksTableView.reloadData()
    }
    
    func didTapOpenAddNewBook() {
        let addNewBookPresenter = AddNewBookPresenter()
        let addNewBookViewController = AddNewBookController(presenter: addNewBookPresenter)
        let navigationController = UINavigationController(rootViewController: addNewBookViewController)
        addNewBookPresenter.view = addNewBookViewController
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController,
                animated: true,
                completion: nil)
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Ошибка!", message: "Произошла ошибка.\nПовторите позднее.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func successDeleteAlert() {
        let alert = UIAlertController(title: "Успешно!", message: "Книга удалена.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Супер!", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension LibraryController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.currentBooks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as? BookTableCell else {
            return .init()
        }
        
        cell.selectionStyle = .none
        //        let book = books[indexPath.row]
        let book = self.presenter.currentBooks[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let book = books[indexPath.row]
        let book = self.presenter.currentBooks[indexPath.row]
        presenter.didTapOpenBook(book: book)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Удалить?", message: "Удаленную книгу не получится восстановить.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Отмена",
                                          style: .cancel,
                                          handler: nil))
            
            alert.addAction(UIAlertAction(title: "Удалить",
                                          style: .destructive,
                                          handler: { _ in
                
                self.presenter.deleteBook(book: self.presenter.currentBooks[indexPath.row], index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                print("book deleted")
                
            }))
            present(alert, animated: true, completion: nil)
            
        }
    }
}

extension LibraryController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
