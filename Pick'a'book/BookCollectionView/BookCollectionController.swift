//
//  BookCollectionController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 03.04.2022.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class BooksCollectionController: UICollectionViewController {
    let presenter: BooksCollectionPresenter!
    let genre: Genre!
    var sortedBooks : [Book]!
    
    init(output: BooksCollectionPresenter, genre: Genre){
        self.presenter = output
        self.genre = genre
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.observeBooks(genre: self.genre)
        
        setCollectionView()
        
        presenter.setViewDelegate(delegate: self)
    }
    
    func reloadCollection() {
        collectionView.reloadData()
    }
    
    func setCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        let size = CGSize(width:(collectionView!.bounds.width - 30), height: 100)
        layout.itemSize = size
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView!.register(BookCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func presentNextVC(selectedBook : Book){
        let presenterB = BookProfilePresenter()
        let owned = checkOwner(selectedBook: selectedBook)
        let vc = BookProfileController(output: presenterB, book: selectedBook, owned: owned)
        self.navigationController?.pushViewController(vc, animated: true)

        vc.navigationController?.navigationBar.tintColor = .black
        vc.modalPresentationStyle = .fullScreen
    }
    
    func checkOwner(selectedBook: Book) -> Bool {
        return selectedBook.ownerId == Auth.auth().currentUser?.uid
    }
}

extension BooksCollectionController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.currentBooks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionCell
        
        let book = self.presenter.currentBooks[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let book = self.presenter.currentBooks[indexPath.row]
           presenter.chosedBook(book: book)
       }
}

